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
        const driver = filteredDrivers[Math.floor(Math.random() * filteredDrivers.length)];

        // update the driver's ordersAccepted
        await db.collection('Drivers').doc(driver.id).update({
            ordersAccepted: admin.firestore.FieldValue.arrayUnion(order.id)
        });

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
const apiKey = "MzlmOWIyNjhiNTY3NDk3MmFhYjQ1NDVlZTNhOGQ3ZDk6MjkwZmQwYTktYzI2NC00ODkzLWFiYjgtMjg3MzE4Y2NkOWYy";

// TODO: create custom plan request
// {
//     "locations": [
//         {
//             "id": "Depot",
//             "type": "DEPOT",
//             "latitude": 49.60804,
//             "longitude": 6.113033,
//             "openingIntervals": [
//                 {
//                     "start": "2020-12-06T08:00:00+00:00",
//                     "end": "2020-12-06T18:00:00+00:00"
//                 }
//             ]
//         },
//         {
//             "id": "Customer",
//             "type": "CUSTOMER",
//             "latitude": 49.609597,
//             "longitude": 6.097412,
//             "openingIntervals": [
//                 {
//                     "start": "2020-12-06T10:00:00+00:00",
//                     "end": "2020-12-06T10:00:10+00:00"
//                 }
//             ]
//         }
//     ],
//     "vehicles": [
//         {
//             "id": "Vehicle1",
//             "profile": "EUR_TRUCK_40T",
//             "capacities": [
//                 500
//             ],
//             "startLocationId": "Depot",
//             "endLocationId": "Depot"
//         },
//         {
//             "id": "Vehicle2",
//             "profile": "EUR_TRUCK_40T",
//             "capacities": [
//                 500
//             ],
//             "startLocationId": "Depot",
//             "endLocationId": "Depot"
//         }
//     ],
//     "transports": [
//         {
//             "id": "Transport1",
//             "quantities": [
//                 100
//             ],
//             "pickupLocationId": "Customer",
//             "pickupServiceTime": 60,
//             "deliveryLocationId": "Depot",
//             "deliveryServiceTime": 60
//         },
//         {
//             "id": "Transport2",
//             "quantities": [
//                 100
//             ],
//             "pickupLocationId": "Depot",
//             "pickupServiceTime": 60,
//             "deliveryLocationId": "Customer",
//             "deliveryServiceTime": 60
//         }
//     ],
//     "planningHorizon": {
//         "start": "2020-12-06T00:00:00+00:00",
//         "end": "2020-12-07T00:00:00+00:00"
//     }
// }

function createPlan() {
    var body = new Object();
    body.name = "Raj";
    body.age = 32;
    body.married = false;

    body.planningHorizon = {
        "start": "2020-12-06T00:00:00+00:00",
        "end": "2020-12-07T00:00:00+00:00"
    }

    var bodyJSONString = JSON.stringify(body);

    fetch("https://api.myptv.com/routeoptimization/v1/plans", {
            method: "POST",
            headers: { apiKey: apiKey, "Content-Type": "application/json" },
            body: bodyJSONString,
        })
        .then(response => response.json())
        .then(result => console.log(result));
}

function optimizePlan(id) {
    fetch("https://api.myptv.com/routeoptimization/v1/plans/${id}/operation/optimization", {
            method: "POST",
            headers: { apiKey: apiKey, "Content-Type": "application/json" },
        })
        .then(response => response.json())
        .then(result => console.log(result));
}

function checkIfPlanIsOptimized(id) {
    fetch("https://api.myptv.com/routeoptimization/v1/plans/${id}/operation", {
            method: "GET",
            headers: { apiKey: "YOUR_API_KEY", "Content-Type": "application/json" },
        })
        .then(response => response.json())
        .then(result => console.log(result));
}

function getPlan(id) {
    fetch("https://api.myptv.com/routeoptimization/v1/plans/${id}", {
            method: "GET",
            headers: { apiKey: "YOUR_API_KEY", "Content-Type": "application/json" },
        })
        .then(response => response.json())
        .then(result => console.log(result));
}