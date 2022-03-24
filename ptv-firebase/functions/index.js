// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

/* import * as functions from 'firebase-functions';

export const roughFilter = functions.firestore
    .document('...')
    .onCreate(async(snapshot, context) => {
        const data = snapshot.data();
        const filteredData = roughFilter(data);


    });
*/

// --------------------------------------------------
// Rough Filter
// --------------------------------------------------
// exclude driver that are more than 5km away
// exclude driver with more than 5 orders
// exclude driver with priority > TODO: set value

function roughFilter() {
    // 5km radius
    const geopointPickup = GeoPoint(10, 10);
    const geopointDriver = GeoPoint(5, 9);

    const distance = distance(geopointPickup, geopointDriver);

    return distance
}

function distance(point1, point2) {
    const diffLat = point1.latitude - point2.latitude;
    const diffLng = point1.longitude - point2.longitude;
    const distance = Math.pow(Math.pow(diffLat, 2) + Math.pow(diffLng, 2), 0.5);
    return distance;
}

roughFilter()