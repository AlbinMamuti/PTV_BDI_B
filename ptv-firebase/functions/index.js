// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();


exports.createNewOrder = functions.firestore
    .document('Orders/{orderId}')
    .onCreate(async(snap, context) => {
        const order = snap.data();
        const filteredDrivers = await roughDriverFilter(order);


    });


// --------------------------------------------------
// Rough Filter
// --------------------------------------------------
// exclude driver that are more than 5km away
// exclude driver with more than 5 orders
// only include drivers with worst 10 ratings

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