import 'package:flutter/material.dart';
import 'package:real_estate/ar/ar_screens_eight.dart';

import '../main.dart';
import 'ar_screens_ten.dart';

class ArScreenSeven extends StatelessWidget {
  const ArScreenSeven({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/8.jpg'), fit: BoxFit.fill)),
        child: Stack(children: [
          Positioned(
            bottom: 380,
            left: 240,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ArScreenEight()));
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(
                  -3.1415926535897932 / 3,
                ),
                child: Image.asset(
                  "images/arrow-right.png",
                  height: 70,
                  width: 70,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 380,
            left: 110,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ArScreenTen()));
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(
                  -3.1415926535897932 / 3,
                ),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(
                    -3.1415926535897932 / 1,
                  ),
                  child: Image.asset(
                    "images/arrow-right.png",
                    height: 70,
                    width: 70,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
