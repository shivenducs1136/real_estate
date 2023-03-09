import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate/screens/home_screen.dart';
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
    Future.delayed(const Duration(milliseconds: 1500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white));
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
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
