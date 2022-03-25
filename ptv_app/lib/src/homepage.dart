import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ptv_app/src/widgets/buttons/fabMenu.dart';
import 'package:ptv_app/src/widgets/dashboard/dashboard.dart';
import 'package:ptv_app/src/widgets/header/customHeader.dart';
import 'package:ptv_app/src/widgets/maps/googleMaps.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'custom/CustomColors.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<HomePage> createState() => _HomePageState(currentUser: user);
}

class _HomePageState extends State<HomePage> {
  User currentUser;
  _HomePageState({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            //CustomHeader(),
            //CustomDashBoard(user: currentUser),
          ],
        ),
      ),
    );
  }
}
