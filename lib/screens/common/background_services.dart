// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:map_location_picker/map_location_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:real_estate/main.dart';
// import 'package:real_estate/model/agent_model.dart';
// import 'package:real_estate/model/customer_model.dart';
// import 'package:real_estate/model/property_model.dart';
// import 'package:real_estate/providers/agent_provider.dart';
// import 'package:real_estate/screens/agent/agent_screen.dart';
// import 'package:real_estate/screens/agent/generate_otp_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   /// OPTIONAL, using custom notification channel id
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'my_foreground', // id
//     'Tiwari Propmarts', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.low, // importance must be at low or higher level
//   );

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // if (Platform.isIOS) {
//   //   await flutterLocalNotificationsPlugin.initialize(
//   //     const InitializationSettings(
//   //       iOS: IOSInitializationSettings(),
//   //     ),
//   //   );
//   // }

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: true,
//       isForegroundMode: true,

//       notificationChannelId: 'my_foreground',
//       initialNotificationTitle: 'Tiwari Propmarts',
//       initialNotificationContent: 'Location Tracking',
//       foregroundServiceNotificationId: 888,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: true,

//       // this will be executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );

//   service.startService();
// }

// // to ensure this is executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.reload();
//   final log = preferences.getStringList('log') ?? <String>[];
//   log.add(DateTime.now().toIso8601String());
//   await preferences.setStringList('log', log);

//   return true;
// }

// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();

//   // For flutter prior to version 3.0.0
//   // We have to register the plugin manually

//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.setString("hello", "world");

//   /// OPTIONAL when use custom notification
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         /// OPTIONAL for use custom notification
//         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//         // if you don't using custom notification, uncomment this
//         service.setForegroundNotificationInfo(
//           title: "Tiwari Propmar",
//           content: "Updated at ${DateTime.now()}",
//         );
//       }
//     }

//     /// you can see this log in logcat
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

//     // test using external plugin
    

//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
        
//       },
//     );
//   });
// }

// // await initializeFirebase();
// //     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
// //         .then((Position position) {
// //       FirebaseFirestore.instance
// //           .collection("tracking")
// //           .doc(provider.getProperty!.id)
// //           .collection(provider.getAgent!.id)
// //           .doc(provider.getCustomer!.customer_id)
// //           .collection("coordinates")
// //           .doc(DateTime.now().millisecondsSinceEpoch.toString())
// //           .set({
// //         'lat': position.latitude.toString(),
// //         'long': position.longitude.toString()
// //       });
// //     });