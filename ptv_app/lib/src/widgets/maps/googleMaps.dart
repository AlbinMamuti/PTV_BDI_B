import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ptv_app/src/util/dataBase.dart';
import 'package:ptv_app/src/util/directions_repository.dart';
import 'package:ptv_app/src/util/types/types.dart';

import '../../custom/CustomColors.dart';

class CustomMainMap extends StatefulWidget {
  User user;
  CustomMainMap({Key? key, required this.user}) : super(key: key);

  @override
  State<CustomMainMap> createState() => _CustomMainMapState(user: user);
}

class _CustomMainMapState extends State<CustomMainMap> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(47.43229, 9.382390);
  //final LatLng _center = const LatLng(45.521563, -122.677433);
  //implement every 30
  // _CustomMainMapState() {

  // }
  User user;
  List<PointLatLng> _info = [];
  List<LocationJson> _routes = [];
  _CustomMainMapState({required this.user}) {}

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<Marker>>(
      future: _genMarkers(),
      builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 1,
            ),
            markers: snapshot.data!,
            polylines: {
              if (false && _info.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('overview'),
                  color: CustomColors.darkDarkLiver,
                  width: 5,
                  points: _info
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
          );
        } else {
          child = Center(
            child: CircularProgressIndicator(
              color: CustomColors.darkLiver,
            ),
          );
        }
        return child;
      },
    );
  }

  Future<Set<Marker>> _genMarkers() async {
    Position currPos = await _determinePosition();
    //database Call
    return {};
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position temp = await Geolocator.getCurrentPosition();
    return temp;
  }
}
