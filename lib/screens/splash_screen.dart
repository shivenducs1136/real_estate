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
    Future.delayed(const Duration(milliseconds: 4000), () async {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      final prefs = await SharedPreferences.getInstance();

      final int loginflag = prefs.getInt('login') ?? 0;
      final String email = prefs.getString('email') ?? '';
      if (loginflag == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else if (loginflag == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AdminScreen()));
      } else if (loginflag == 2) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => AgentScreen(
                      email: email,
                    )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //appbar
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: MediaQuery.of(context).size.width * .6,
            width: MediaQuery.of(context).size.width * .6,
            child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image.asset("images/company_logo.jpeg"))),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Another sweet home 🏠 win 🏆",
            style: TextStyle(
                fontSize: 16, color: Colors.black87, letterSpacing: .5),
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }
}
