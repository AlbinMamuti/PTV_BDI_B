import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInController extends GetxController {
  var _googleSignin = GoogleSignIn();

  var googleAccout = Rx<GoogleSignInAccount?>(null);

  login() async {
    googleAccout.value = await _googleSignin.signIn();
  }
}
