import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class OtpAuth {
  static String verifId = "";
  static Future<int> sendOtp(String phoneNumber) async {
    int res = 0;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) {
        log("verificationCompleted");
        res = 1;
      },
      verificationFailed: (FirebaseAuthException e) {
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
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verifId, smsCode: pin);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
