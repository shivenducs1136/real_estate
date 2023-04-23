import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'firebase_options.dart';

late Size mq;
SharedPreferences? msprefs;
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    print("Task Executing " + taskName);
    await initializeFirebase();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      await FirebaseFirestore.instance
          .collection("tracking")
          .doc(inputData!['propertyId'])
          .collection(inputData!['agentId'])
          .doc(inputData!['customerId'])
          .collection("coordinates")
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'lat': position.latitude.toString(),
        'long': position.longitude.toString()
      });
    });
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
      .then((value) async {
    await initializeFirebase();

    runApp(const MyApp());
  });
  FocusManager.instance.primaryFocus?.unfocus();
  msprefs = await SharedPreferences.getInstance();
}

initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AgentProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
