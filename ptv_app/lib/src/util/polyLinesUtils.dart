import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ptv_app/.env.dart';
import 'package:http/http.dart' as http;
import 'package:http_retry/http_retry.dart';

class PolyLinesUtils {
  List<LatLng> wayPoints;
  PolyLinesUtils({required this.wayPoints});
  Future<List<Polyline>> callerCreatePolyLines() async {
    String urlPTV = 'https://api.myptv.com/routing/v1/routes?';
    String results = '&results=POLYLINE';
    String apiKey = '&apiKey=$ptvApiKey';
    String wayPointsString = '';
    for (int i = 0; i < wayPoints.length; i += 1) {
      var temp = wayPoints[i];
      wayPointsString += 'waypoints=${temp.latitude},${temp.longitude}';
      wayPointsString += '&';
    }
    String jsonResponse =
        await fetchHTTP((urlPTV + wayPointsString + results + apiKey));
    var polyLine = jsonDecode(jsonDecode(jsonResponse)['polyline']);
    var coordAsLatLng = (polyLine['coordinates'] as List)
        .map((ell) => LatLng(ell[1], ell[0]))
        .toList();
    var polyLines = [
      Polyline(
        points: coordAsLatLng,
        strokeWidth: 4,
        color: Color.fromARGB(255, 243, 146, 0),
      ),
    ];
    return polyLines;
  }

  Future<String> fetchHTTP(String url) async {
    final client = RetryClient(http.Client());
    try {
      final response = await client.read(Uri.parse(url));
      return response;
    } finally {
      client.close();
    }
  }
}
