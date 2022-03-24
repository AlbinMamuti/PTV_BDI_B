// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

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
    });

// --------------------------------------------------
// API
// --------------------------------------------------
const apiKey = "MzlmOWIyNjhiNTY3NDk3MmFhYjQ1NDVlZTNhOGQ3ZDk6MjkwZmQwYTktYzI2NC00ODkzLWFiYjgtMjg3MzE4Y2NkOWYy";
const baseURLplan = "https://api.myptv.com/routeoptimization/v1/plans"