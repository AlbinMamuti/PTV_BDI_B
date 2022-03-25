import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ptv_app/src/login_controller.dart';

class LoginPage extends StatelessWidget {
  //const LoginPage({Key? key}) : super(key: key);
  final controller = Get.put(LogInController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Obx(() {
          if (controller.googleAccout.value == null) {
            return buttonSignInBuilder();
          } else {
            return signInPageBuilder();
          }
        }),
      ),
    );
  }

  Column buttonSignInBuilder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton.extended(
            onPressed: () {
              controller.login();
            },
            label: Text('Sign in with Google'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            icon: Image.asset(
              '/Users/albinmamuti/Projects/maliqi_app_v4/assets/images/google_logo.jpeg',
              height: 32,
              width: 32,
            ))
      ],
    );
  }

  Column signInPageBuilder() {
    return Column(
      children: [const Text('Hello World')],
    );
  }
}
