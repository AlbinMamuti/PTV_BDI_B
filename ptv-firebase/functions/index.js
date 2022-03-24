// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

// Hello World
exports.helloWorld = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
});


exports.createNewObject = functions.firestore
    .document('orders/{orderId}')
    .onCreate(async(snapshot, context) => {
        const data = snapshot.data();
        const order = data.order;
        functions.logger.info(orderId);
        const filteredData = roughFilter(data);

    });


// --------------------------------------------------
// Rough Filter
// --------------------------------------------------
// exclude driver that are more than 5km away
// exclude driver with more than 5 orders
// exclude driver with priority > TODO: set value

function roughFilter() {
    // 5km radius
    const geopointPickup = new admin.firestore.GeoPoint(10, 10);
    const geopointDriver = new admin.firestore.GeoPoint(5, 9);

    const dist = distance(geopointPickup, geopointDriver);

    return (dist < 5);
}

function distance(point1, point2) {
    const diffLat = point1.latitude - point2.latitude;
    const diffLng = point1.longitude - point2.longitude;
    const distance = Math.pow(Math.pow(diffLat, 2) + Math.pow(diffLng, 2), 0.5);
    return distance;
}

console.log(roughFilter())