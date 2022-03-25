import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:ptv_app/src/util/types/types.dart';

class getDataDatabase {
  static Stream<DocumentSnapshot> getDriverStream(User user) {
    return FirebaseFirestore.instance
        .collection('Driver')
        .doc('UyqMs2696YZJv3SoEZTm')
        .snapshots();
  }

  static void sendCancel(User user) async {
    CollectionReference Drivers =
        FirebaseFirestore.instance.collection('Drivers');
    var list = (await Drivers.where('Email', isEqualTo: user.email).get()).docs;
    String idtolook = list[0].id;
    Drivers.doc(idtolook).set(
      {
        'Flag': 1,
      },
      SetOptions(merge: true),
    );
  }

  static void sendOk(User user) async {
    CollectionReference Drivers =
        FirebaseFirestore.instance.collection('Drivers');
    var list = (await Drivers.where('Email', isEqualTo: user.email).get()).docs;
    String idtolook = list[0].id;
    String routeToUpdate = (list[0].data() as Map<String, dynamic>)['Route'];
    Drivers.doc(idtolook).set(
      {
        'Flag': 2,
        'Route': routeToUpdate,
      },
      SetOptions(merge: true),
    );
  }

  static Future<Map<String, dynamic>> getDriver(User user) async {
    CollectionReference Drivers =
        FirebaseFirestore.instance.collection('Drivers');
    var documents =
        (await Drivers.where('Email', isEqualTo: user.email).get()).docs;
    Map<String, dynamic> data = {};
    if (documents.length == 0) {
      return data;
    }
    data = documents[0].data() as Map<String, dynamic>;
    return data;
  }

  static Future<List<LocationJson>> getRoute(User user) async {
    Map<String, dynamic> data = await getDriver(user);
    String routeInfo = data['Route'] as String;
    Map<String, dynamic> routeObj = jsonDecode(routeInfo);

    List<LocationJson> locations = [];
    Map<String, LocationJson> dictLoc = {};
    routeObj["locations"].forEach((ell) {
      LocationJson temp = new LocationJson(
          id: ell["id"],
          type: ell["type"],
          lat: ell["latitude"],
          long: ell["longitude"]);
      locations.add(temp);
      dictLoc.addAll({ell["id"]: temp});
    });

    List<dynamic> routes = routeObj["routes"];
    var temp = routes[0];
    List<String> reihenfolge = [];
    List<LocationJson> ret = [];
    List<dynamic> stops = temp["stops"];
    stops.forEach((element) {
      reihenfolge.add(element["locationId"]);
      ret.add(dictLoc[element["locationId"]]!);
    });
    return ret;
  }

  static Future<List<DateTime>> getTimes(User user) async {
    CollectionReference ArbeiterStunden =
        FirebaseFirestore.instance.collection('Arbeiterstunden');
    List<DateTime> toRet = [];
    DateTime today = DateTime.now();

    DateTime mostRecentWeekday(DateTime date, int weekday) => DateTime(
        date.year, date.month, date.day - (date.weekday - weekday) % 7);

    var dataBase = ArbeiterStunden.where('Anfang',
            isGreaterThanOrEqualTo: mostRecentWeekday(today, 1))
        .where('Email', isEqualTo: user.email);
    var break1 = await dataBase.get();
    var break2 = break1.docs;
    break2.forEach((element) {
      Map<String, dynamic> data = element.data()! as Map<String, dynamic>;
      var temp = DateTime.parse(data['Anfang'].toDate().toString());
      toRet.add(temp);
    });
    toRet.sort();
    //
    return toRet;
  }
}
