import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:real_estate/screens/common/background_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpAuth {
  static String verifId = "";
  static Future<int> sendOtp(String phoneNumber) async {
    int res = 0;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        log("verificationCompleted");
        res = 1;
        await initializeService();
        await FirebaseAuth.instance.signInWithCredential(credential);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isTracking', true);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        log("verificationFailed");
        res = 2;
      },
      codeSent: (String verificationId, int? resendToken) {
        verifId = verificationId;
        log("codeSent");
        res = 3;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log("codeAutoRetrievalTimeout");
        verifId = verificationId;
        res = 4;
      },
    );
    return res;
  }

  static void verifyOtp(String pin) async {
    log("Verify otp initiated");
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verifId, smsCode: pin);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
