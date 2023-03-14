import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate/screens/admin/admin_screen.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:real_estate/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));
      final prefs = await SharedPreferences.getInstance();

      final int loginflag = prefs.getInt('login') ?? 0;
      if (loginflag == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else if (loginflag == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AdminScreen()));
      } else if (loginflag == 2) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AgentScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //appbar
      body: Stack(children: [
        Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset("images/house.png")),
        Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text(
              "Another sweet home 🏠 win 🏆",
              style: TextStyle(
                  fontSize: 16, color: Colors.black87, letterSpacing: .5),
              textAlign: TextAlign.center,
            )),
      ]),
    );
  }
}
