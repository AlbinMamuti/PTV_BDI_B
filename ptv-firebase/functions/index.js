// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

// Import fetch for Node.js
const fetch = require('node-fetch');

const db = admin.firestore();

exports.newOrder = functions.firestore
    .document('Orders/{orderId}')
    .onCreate(async(snap, context) => {
        const order = snap.data();
        const filteredDrivers = await roughDriverFilter(order);

        // select one driver from the filtered list
        // TODO: select driver based on score
        const driver = filteredDrivers[0];
        const priorityGain = 0;

        filteredDrivers.sort(function(a, b) {
            const moneyFromOrder = order.priority * getDistance(order.PickupLocation, order.DropoffLocation)
            const aNewPriority = (a.MoneyEarned + moneyFromOrder) / testNewRoute(a, order)[1];
            const bNewPriority = (b.MoneyEarned + moneyFromOrder) / testNewRoute(b, order)[1];

            return (bNewPriority - b.priority) - (aNewPriority - a.priority);
        });

        // update the driver's ordersAccepted


        // update order status


        return Promise.resolve();
    });

// --------------------------------------------------
// Rough Filter
// --------------------------------------------------
// - exclude driver that are more than 5km away
// - exclude driver with more than 5 orders
// - only include drivers with worst 10 priority
// 
// @returns {Array} of drivers sorted by priority

async function roughDriverFilter(order) {
    const geopointPickup = order.Pickup;

    var drivers = [];

    // filter number of orders
    const query = await db.collection('Drivers').where('ordersAccepted', '<', 5).get();

    // filter based on distance
    query.docs.forEach(doc => {
        const driver = doc.data();
        const distance = getDistance(geopointPickup, driver.location);

        if (distance < 5) {
            drivers.push(driver);
        }
    });

    // only return 10 drivers with the lowest score
    drivers.sort(function(a, b) {
        return a.priority - b.priority
    });

    drivers.length = Math.min(drivers.length, 10);

    return drivers;
}

function getDistance(point1, point2) {
    const diffLat = point1.latitude - point2.latitude;
    const diffLng = point1.longitude - point2.longitude;
    const distance = Math.pow(Math.pow(diffLat, 2) + Math.pow(diffLng, 2), 0.5);
    return distance;
}

// Function that automatically updates the CurrentOrdersAmount of a driver
// after he delivers a order or accepts a new one
exports.updateCurrentOrderAmount = functions.firestore
    .document('Drivers/{driverId}')
    .onUpdate((change, context) => {
        const driver = change.after.data()
        const newOrderAmount = driver.Orders.length;

        change.after.ref.update({
            CurrentOrdersAmount: newOrderAmount
        });

        return Promise.resolve();
    });

// --------------------------------------------------
// API
// --------------------------------------------------
const noak = "MzlmOWIyNjhiNTY3NDk3MmFhYjQ1NDVlZTNhOGQ3ZDk6MjkwZmQwYTktYzI2NC00ODkzLWFiYjgtMjg3MzE4Y2NkOWYy";

function createPlan(driver, order) {
    var body = new Object();

    body.locations = new Array();
    body.locations.push({
        "id": "Start",
        "latitude": driver.location.latitude,
        "longitude": driver.location.longitude
    });

    body.locations.push({
        "id": "Pickup" + order.id,
        "latitude": order.Pickup.latitude,
        "longitude": order.Pickup.longitude
    });

    body.locations.push({
        "id": "Dropoff" + order.id,
        "latitude": order.Dropoff.latitude,
        "longitude": order.Dropoff.longitude
    });

    body.vehicles = new Array();
    body.vehicles.push({
        "id": "Bicycle",
        "startLocationId": "Start"
    });

    body.transports = new Array();
    body.transports.push({
        "id": order.id,
        "pickupLocationId": "Pickup" + order.id,
        "deliveryLocationId": "Dropoff" + order.id,
        "priority": order.priority
    });

    body.planningHorizon = {
        "start": "2020-12-06T00:00:00.0000000+00:00",
        "end": "2020-12-07T00:00:00.0000000+00:00"
    }

    body.routes = new Array();

    if (driver.hasOwnProperty('route')) {
        body.routes.push(JSON.parse(driver.route))
    }

    var bodyJSONString = JSON.stringify(body);

    const result = fetch("https://api.myptv.com/routeoptimization/v1/plans", {
            method: "POST",
            headers: { apiKey: noak, "Content-Type": "application/json" },
            body: bodyJSONString,
        })
        .then(response => response.json())
        .then(result => result["id"]);

    return result
}

function optimizePlan(id) {
    const url = "https://api.myptv.com/routeoptimization/v1/plans/" + id + "/operation/optimization?considerTransportPriorities=true";
    fetch(url, {
        method: "POST",
        headers: { apiKey: noak, "Content-Type": "application/json" }
    });
}

async function checkIfPlanIsOptimized(id) {
    const url = "https://api.myptv.com/routeoptimization/v1/plans/" + id + "/operation";

    var result = await (fetch(url, {
            method: "GET",
            headers: { apiKey: noak, "Content-Type": "application/json" },
        })
        .then(response => response.json()));

    while (result["status"] != "SUCCEEDED") {
        result = await (fetch(url, {
                method: "GET",
                headers: { apiKey: noak, "Content-Type": "application/json" },
            })
            .then(response => response.json()));
    }
}

function getPlan(id) {
    const url = "https://api.myptv.com/routeoptimization/v1/plans/" + id;
    const result = fetch(url, {
            method: "GET",
            headers: { apiKey: noak, "Content-Type": "application/json" },
        })
        .then(response => response.json());

    return result;
}

function deletePlan(id) {
    const url = "https://api.myptv.com/routeoptimization/v1/plans/" + id;
    fetch(url, {
            method: "DELETE",
            headers: { apiKey: noak, "Content-Type": "application/json" },
        })
        .then(response => response.json());
}

async function updateRoute(driver, order) {
    const id = await createPlan(driver, order);
    optimizePlan(id);
    await checkIfPlanIsOptimized(id);
    getPlan(id).then(result => {
        driver.route = JSON.stringify(result["routes"][0]);
    });
    deletePlan(id);
}

async function testNewRoute(driver, order) {
    const id = await createPlan(driver, order);
    optimizePlan(id);
    await checkIfPlanIsOptimized(id);
    getPlan(id).then(result => {
        return [
            result["routes"][0]["report"]["travelTime"] - JSON.parse(driver.route)[0]["report"]["travelTime"],
            result["routes"][0]["report"]["distance"] - JSON.parse(driver.route)[0]["report"]["distance"]
        ];
    });
    deletePlan(id);
}