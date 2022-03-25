import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ptv_app/src/util/dataBase.dart';
import 'package:ptv_app/src/util/types/types.dart';

import '../../../.env.dart';

class MapView extends StatefulWidget {
  @override
  User user;
  MapView({required this.user});
  _MapViewState createState() => _MapViewState(user: user);
}

class _MapViewState extends State<MapView> {
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(47.433746, 9.385427));
  late GoogleMapController mapController;

  late Position _currentPosition;
  late List<LocationJson> _routeAsList;
  String _currentAddress = '';

  bool _stateShowPopUp = false;

  Set<Marker> markers = {};

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  User user;

  _MapViewState({required this.user}) {
    user = user;
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 10.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
    await getDataDatabase.getRoute(user).then((List<LocationJson> resp) async {
      setState(() {
        _routeAsList = resp;
      });
    });
    await callerCreatePolyLines();
    var _set = _routeAsList
        .map((e) => Marker(
              markerId: MarkerId(e.id),
              position: LatLng(e.lat, e.long),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: '${e.type}'),
            ))
        .toSet();
    setState(() {
      markers = _set;
    });
  }

  callerCreatePolyLines() async {
    await _createPolylines(_currentPosition.latitude,
        _currentPosition.longitude, _routeAsList[0].lat, _routeAsList[0].long);
    for (int i = 0; i < _routeAsList.length - 1; i += 1) {
      var temp = _routeAsList[i];
      var temp1 = _routeAsList[i + 1];
      await _createPolylines(temp.lat, temp.long, temp1.lat, temp1.long);
    }
    setState(() {
      PolylineId id = PolylineId('poly');
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );
      polylines[id] = polyline;
    });
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  //Stream<DocumentSnapshot> documentStream = Stream.empty();
  final FB = FirebaseFirestore.instance;
  late StreamSubscription Sub;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Sub = getupdate();
    //documentStream = getDataDatabase.getDriverStream(user);
  }

  StreamSubscription getupdate() {
    return FB.collection('Driver').snapshots().listen((event) {
      event.docChanges.forEach((element) {
        print('entered');
        var data = element.doc.data() as Map<String, dynamic>;
        if (data['Email'] == user.email) {
          if (data['Field'] != 3) {
            setState(() {
              _stateShowPopUp = true;
            });
          }
          setState(() {
            _routeAsList = data['Newroute'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            !_stateShowPopUp ? Container() : showDataAlert(),
            // Show zoom buttons
          ],
        ),
      ),
    );
  }

  showDataAlert() {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('New Order Came in!'),
          content: Text('Please accept or deny Order'),
          actions: [
            CupertinoDialogAction(
              child: Text('Annehmen'),
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.of(context).pop();
                });

                getDataDatabase.sendOk(user);
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.of(context).pop();
                });
                getDataDatabase.sendCancel(user);
              },
            )
          ],
        );
      },
    );
  }
}
