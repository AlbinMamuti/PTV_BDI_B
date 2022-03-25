import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ptv_app/src/util/types/directions_model.dart';
import 'package:http/http.dart' as http;
import '../../.env.dart';

class DirectionsRepository {
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";
  static Future<Directions> fetchDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    String originString = 'origin=${origin.latitude},${origin.longitude}';
    String destString =
        'destination=${destination.latitude},${destination.longitude}';
    print('kek');
    final resp = await http.get(Uri.parse(_baseUrl +
        '&' +
        originString +
        '&' +
        destString +
        'key=' +
        googleApiKey));
    if (resp.statusCode == 200) {
      return Directions.fromMap(jsonDecode(resp.body));
    } else {
      throw Exception('Failed to load!');
    }
  }
}
