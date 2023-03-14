import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class APIs {
  static bool isLoggedin = false;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static bool adminLogin(String loginId, String password) {
    if (loginId == "admin" && password == "123") {
      return true;
    }
    return false;
  }

  static Future<bool> agentLogin(String agentEmail, String password) async {
    final data = await firestore.collection('agent').doc(agentEmail).get();

    log('data : $data');
    if (data.exists) {
      if (data.get('password').toString() == password) {
        return true;
      }
    }
    return false;
  }
}
