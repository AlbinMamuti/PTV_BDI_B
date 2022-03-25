// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ptv_app/src/util/dataBase.dart';
import 'package:ptv_app/src/util/types/types.dart';

import '../../../.env.dart';
import '../../custom/CustomColors.dart';
import '../buttons/fabMenu.dart';

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

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  bool _stateShowPopUp = false;
  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;

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
      var me = (await FB
          .collection('Drivers')
          .where('Email', isEqualTo: user.email)
          .get());
      String meString = me.docs[0].id;

      FB.collection('Drivers').doc(meString).set(
          {'Location': GeoPoint(position.latitude, position.longitude)},
          SetOptions(merge: true));
      setState(() {
        if (me.docs[0].data()['Flag'] == 0) {
          setState(() {
            _stateShowPopUp = !_stateShowPopUp;
          });
        }
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15.0,
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
    print(_routeAsList.toString());
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
  late Timer timer;
  late StreamSubscription Sub;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Sub = getupdate();
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _getCurrentLocation();
      print(_stateShowPopUp);
    });
    //documentStream = getDataDatabase.getDriverStream(user);
  }

  StreamSubscription getupdate() {
    return FB.collection('Driver').snapshots().listen((event) {
      event.docChanges.forEach((element) {
        print('entered: : : : : : :');
        var data = element.doc.data() as Map<String, dynamic>;
        if (data['Email'] == user.email) {
          if (data['Flag'] != 3) {
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
        floatingActionButton: ExpandableFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: CustomColors.darkDarkLiver,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_back_ios, color: CustomColors.snow),
                  label: 'Zurück',
                  backgroundColor: CustomColors.snow),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.portable_wifi_off_outlined,
                    color: CustomColors.snow,
                  ),
                  label: 'Profile',
                  backgroundColor: CustomColors.snow),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings, color: CustomColors.snow),
                label: 'Settings',
              ),
            ]),
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
            StreamBuilder(
                stream: FB
                    .collection('Drivers')
                    .doc('UyqMs2696YZJv3SoEZTm')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text('Error');
                  } else {
                    //print(snapshot.data!.data());
                    return func((snapshot.data?.data()!['Flag'] == 0));
                  }
                })
            // Show zoom buttons
          ],
        ),
      ),
    );
  }

  DraggableScrollableSheet func(bool flag) {
    print(flag);
    return DraggableScrollableSheet(
      initialChildSize: 0.08,
      minChildSize: 0.08,
      maxChildSize: 0.35,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          clipBehavior: Clip.hardEdge,
          child: Container(
            color: CustomColors.darkLiver,
            child: Column(
              children: [
                createRowWithByc(),
                (flag)
                    ? Container(
                        height: 350,
                        color: CustomColors.darkDarkLiver,
                        child: createRows(),
                      )
                    : Container(
                        height: 350,
                        color: CustomColors.darkDarkLiver,
                        child: createRowsSimple(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container createRowWithByc() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'assets/Logo_version2.png',
              height: 30,
              color: CustomColors.snow,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Dashboard',
              style: GoogleFonts.inter(
                textStyle: TextStyle(color: CustomColors.snow),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column createRows() {
    int len = _routeAsList.length;
    Column ret = Column(
      children: [],
    );
    ret.children.add(Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Neuen Auftrag aufnhemne?',
              style: GoogleFonts.inter(color: CustomColors.snow),
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              getDataDatabase.sendCancel(user);
            },
            style: ElevatedButton.styleFrom(
              primary: CustomColors.vermillion,
              textStyle:
                  GoogleFonts.inter(fontSize: 15, color: CustomColors.snow),
            ),
            child: Text(
              'Decline',
              style: GoogleFonts.inter(
                color: CustomColors.snow,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getDataDatabase.sendOk(user);
            },
            style: ElevatedButton.styleFrom(
              primary: CustomColors.pastelGreen,
              textStyle:
                  GoogleFonts.inter(fontSize: 15, color: CustomColors.snow),
            ),
            child: Text(
              'Accept',
              style: GoogleFonts.inter(
                color: CustomColors.snow,
              ),
            ),
          ),
        ],
      ),
    ));
    for (int i = 0; i < len - 1; i++) {
      ret.children.add(Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '${_routeAsList[i].id}',
              style: GoogleFonts.inter(
                textStyle: TextStyle(color: CustomColors.snow),
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '${_routeAsList[i + 1].id}',
              style: GoogleFonts.inter(
                textStyle: TextStyle(color: CustomColors.snow),
              ),
            ),
          ),
        ],
      ));
    }
    return ret;
  }

  Column createRowsSimple() {
    int len = _routeAsList.length;
    Column ret = Column(
      children: [],
    );

    for (int i = 0; i < len - 1; i++) {
      ret.children.add(Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '${_routeAsList[i].id}',
              style: GoogleFonts.inter(
                textStyle: TextStyle(color: CustomColors.snow),
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '${_routeAsList[i + 1].id}',
              style: GoogleFonts.inter(
                textStyle: TextStyle(color: CustomColors.snow),
              ),
            ),
          ),
        ],
      ));
    }
    return ret;
  }
}
