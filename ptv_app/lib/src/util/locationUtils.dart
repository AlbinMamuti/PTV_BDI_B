import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  late LocationSettings locationSettings;
  late Stream<Position> positionStream;
  LocationUtils() {
    locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings);
  }
  Stream<Position> getPositionStream() {
    return this.positionStream;
  }
}
