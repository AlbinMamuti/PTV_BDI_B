import 'package:flutter/material.dart';
import 'package:ptv_app/src/util/authentification.dart';
import 'package:ptv_app/src/widgets/buttons/google_sign_in.dart';
import 'custom/CustomColors.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final String assetName =
      '/Users/albinmamuti/Projects/PTV/PTV_BDI_B/ptv_app/assets/PTVGROUP.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.darkLiver,
      // ignore: prefer_const_constructors
      body: SafeArea(
        // ignore: prefer_const_constructors
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color:
                                  CustomColors.darkDarkLiver.withOpacity(0.6),
                              spreadRadius: 13,
                              blurRadius: 28,
                              offset:
                                  Offset(3, 6), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/Logo_version2.png',
                          color: CustomColors.snow,
                        )),
                  ],
                ),
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Fehler, Bitte neustarten');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton(); //IMPLEMENT
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.firebaseGrey),
                  );
                },
              ),
              // Container(
              //   padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              //   //color: Colors.black12,
              //   child: Text(
              //     'register',
              //     style: TextStyle(color: CustomColors.snow),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
