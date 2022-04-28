import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ptv_app/src/sign_in_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('de_CH', null);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PTV_BDI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
    );
  }
}
