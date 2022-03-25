import 'package:geolocator/geolocator.dart';

class LocationJson {
  String id;
  String type;
  late Position position;
  double lat;
  double long;
  LocationJson(
      {required this.id,
      required this.type,
      required this.lat,
      required this.long}) {
    position = new Position(
        longitude: long,
        latitude: lat,
        timestamp: DateTime(0),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0);
  }
}
