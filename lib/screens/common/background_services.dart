import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/screens/agent/generate_otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on("setAsForeground").listen((event) {
      service.setAsForegroundService();
    });
    service.on("setAsBackground").listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on("stopService").listen((event) {
    service.stopSelf();
  });
  Timer.periodic(Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: "Tiwari Propmart", content: "Location Tracking...");
      }
    }
    // perform background operations
    print("background service running");
    await initializeFirebase();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String agentId = prefs.getString('agentId').toString();
    String customerId = prefs.getString('customerId').toString();
    String propertyId = prefs.getString('propertyId').toString();

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      FirebaseFirestore.instance
          .collection("tracking")
          .doc(propertyId)
          .collection(agentId)
          .doc(customerId)
          .collection("coordinates")
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'lat': position.latitude.toString(),
        'long': position.longitude.toString()
      });
    });
    service.invoke("update");
  });
}
