import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpAuth {
  static Future<int> sendOtp(String phoneNumber, BuildContext context) async {
    int res = -1;
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        log("verificationCompleted");
        Dialogs.showSnackbar(context, "Verification Completed");
        res = 0;
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        res = 2;
        log("verificationFailed");
        Dialogs.showSnackbar(context, "Server Problem: Verification Failed");
      },
      codeSent: (String verificationId, int? resendToken) async {
        log("codeSent");
        res = 3;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('verificationId', verificationId);
        Dialogs.showSnackbar(context, "Code Sent");
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        log("codeAutoRetrievalTimeout");
        res = 4;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('verificationId', verificationId);
      },
    )
        .onError((error, stackTrace) {
      Dialogs.showSnackbar(context, error.toString());
      res = 5;
    });
    return res;
  }

  static Future<int> verifyOtp(String pin, BuildContext context) async {
    log("${pin}");
    int res = -2;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String verifId = prefs.getString("verificationId").toString();
    try {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: verifId, smsCode: pin);
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .whenComplete(() async {
        if (FirebaseAuth.instance.currentUser != null) {
          Dialogs.showSnackbar(context, "Customer Verified");
          Navigator.pop(context);
          res = 1;
        }
        res = -1;
      });
      return 1;
    } catch (e) {
      Dialogs.showSnackbar(context, e.toString());
      res = 0;
    }
    return res;
  }
}
