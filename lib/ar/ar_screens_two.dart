import 'package:flutter/material.dart';
import 'package:real_estate/ar/ar_screens_four.dart';
import 'package:real_estate/ar/ar_screens_three.dart';

import '../main.dart';

class ArScreenTwo extends StatelessWidget {
  const ArScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/2.jpg'), fit: BoxFit.fill)),
        child: Stack(children: [
          Positioned(
            bottom: 320,
            left: 80,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ArScreenThree()));
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(
                  -3.1415926535897932 / 3,
                ),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(
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
          ),
          Positioned(
            bottom: 350,
            left: 250,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ArScreenFour()));
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(
                  -3.1415926535897932 / 3,
                ),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(
                    -3.1415926535897932 / 4,
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
