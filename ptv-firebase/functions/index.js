// Import fetch for Node.js
const fetch = require('node-fetch');

// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

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

exports.newOrder = functions.firestore
    .document('Orders/{orderId}')
    .onCreate(async(snap, context) => {
        const order = snap.data();
        const filteredDrivers = await roughDriverFilter(order);

        // order drivers from the filtered list by possible gain
        // filteredDrivers.sort(function(a, b) {
        //     const moneyFromOrder = order.priority * getDistance(order.PickupLocation, order.DropoffLocation)
        //     const aNewPriority = (a.MoneyEarned + moneyFromOrder) / testNewRoute(a, order)[1];
        //     const bNewPriority = (b.MoneyEarned + moneyFromOrder) / testNewRoute(b, order)[1];

        //     return (bNewPriority - b.priority) - (aNewPriority - a.priority);
        // });

        const driver = filteredDrivers[0];

        await db.collection('Drivers').doc(driver.id).set({
            NewRoute: await testNewRoute(driver.data(), order)
        }, { merge: true });

        await db.collection('Drivers').doc(driver.id).set({
            Flag: 0
        }, { merge: true });

        while (driver.data().Flag == 0) {
            await sleep(2000);
        }

        if (driver.data().Flag == 2) {
            await db.collection('Drivers').doc(driver.id).set({
                Rout: updateRoute(driver.data(), order)
            }, { merge: true });

            await db.collection('Orders').doc(context.id).set({
                Status: 1
            }, { merge: true });
        }

        // // update the driver's ordersAccepted
        // filteredDrivers.forEach(async driver => {
        //     if (order.status == 0) {
        //         driver.routeNew = await testNewRoute(driver, order);

        //         while (driver.flag == 0) {}

        //         if (driver.flag == 2) {
        //             updateRoute(driver, order);
        //             order.status = 1;
        //         }
        //     }
        // });

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
    // const geopointPickup = order.PickupLocation;

    var drivers = [];

    // filter number of orders
    const query = await db.collection('Drivers').where('CurrentOrdersAmount', '<', 5).get();

    // filter based on distance
    query.docs.forEach(doc => {
        // const driver = doc.data();
        // const distance = getDistance(geopointPickup, driver.Location);

        // if (distance < 5) {
        drivers.push(doc);
        // }
    });

    // only return 10 drivers with the lowest score
    drivers.sort(function(a, b) {
        return a.data().priority - b.data().priority
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

// --------------------------------------------------
// API Requests
// --------------------------------------------------
const noak = "MzlmOWIyNjhiNTY3NDk3MmFhYjQ1NDVlZTNhOGQ3ZDk6MjkwZmQwYTktYzI2NC00ODkzLWFiYjgtMjg3MzE4Y2NkOWYy";

function createPlan(driver, order) {
    var body = new Object();

    body.routes = new Array();
    body.locations = new Array();
    body.transports = new Array();

    if (driver['Route'] != "") {
        const plan = JSON.parse(driver.Route);
        body.routes.push(plan.routes[0]);
        body.transports = plan.transports;
        body.locations = plan.locations;
    } else {
        body.locations.push({
            "id": "Start",
            "latitude": driver.Location.latitude,
            "longitude": driver.Location.longitude
        });
    }

    body.locations.push({
        "id": "Pickup" + order.Description,
        "latitude": order.PickupLocation.latitude,
        "longitude": order.PickupLocation.longitude
    });

    body.locations.push({
        "id": "Dropoff" + order.Description,
        "latitude": order.DropoffLocation.latitude,
        "longitude": order.DropoffLocation.longitude
    });

    body.vehicles = new Array();
    body.vehicles.push({
        "id": "Bicycle",
        "startLocationId": "Start"
    });


    body.transports.push({
        "id": order.Description,
        "pickupLocationId": "Pickup" + order.Description,
        "deliveryLocationId": "Dropoff" + order.Description,
        "priority": order.Priority
    });

    body.planningHorizon = {
        "start": "2020-12-06T00:00:00.0000000+00:00",
        "end": "2020-12-07T00:00:00.0000000+00:00"
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
    return getPlan(id).then(result => JSON.stringify(result));

    // deletePlan(id);
}

async function testNewRoute(driver, order) {
    const id = await createPlan(driver, order);
    optimizePlan(id);
    await checkIfPlanIsOptimized(id);
    return getPlan(id).then(result => JSON.stringify(result));
    //deletePlan(id);
}

// async function customRoute() {
//     const order1 = {
//         "id": "1",
//         "Status": 0,
//         "PickupLocation": {
//           "latitude": 47.415191650390625,
//           "longitude": 8.546640396118164
//         },
//         "DropoffLocation": {
//           "latitude": 47.37395095825195,
//           "longitude": 8.54990005493164
//         },
//         "Description": "PacketN",
//         "ClientID": "1",
//         "Priority": 6
//       };

//     const order2 = {
//         "id": "2",
//         "PickupLocation": {
//             "latitude": 47.43510110473633,
//             "longitude": 9.386520385742188
//           },
//         "DropoffLocation": {
//           "latitude": 47.42802047729492,
//           "longitude": 9.38125991821289
//         },
//         "Description": "Ramen",
//         "ClientID": "1",
//         "Status": 0,
//         "Priority": 1
//       };

//     const order3 = {
//         "id": "3",
//         "DropoffLocation": {
//           "latitude": 47.43275833129883,
//           "longitude": 9.378490447998047
//         },
//         "Status": 0,
//         "Description": "Pizza",
//         "ClientID": "1",
//         "PickupLocation": {
//           "latitude": 47.43410110473633,
//           "longitude": 9.386520385742188
//         },
//         "Priority": 3
//       };

//       var driver = {
//         "Orders": [
//           "projects/ptvhack22/databases/(default)/documents/Orders/KMYG29vVFNjIFdjWYG1i"
//         ],
//         "DistanceTravelled": 10.5,
//         "MoneyEarned": 65.75,
//         "CurrentOrdersAmount": 1,
//         "Name": "Albin",
//         "Email": "albinmamuti00@gmail.com",
//         "Route": "",
//         "Location": {
//           "latitude": 47.43364,
//           "longitude": 9.384147
//         },
//         "Priority": 0
//       };

//       driver.Route = await updateRoute(driver, order1);
//       driver.Route = await updateRoute(driver, order2);
//       driver.Route = await updateRoute(driver, order3);
//       const json = JSON.parse(driver.Route);
//       console.log(json.routes[0].stops);
//   }

// customRoute();