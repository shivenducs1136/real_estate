import 'package:flutter/material.dart';
import 'package:real_estate/ar/ar_screens_seven.dart';

import '../main.dart';

class ArScreenSix extends StatelessWidget {
  const ArScreenSix({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/7.jpg'), fit: BoxFit.fill)),
        child: Stack(children: [
          Positioned(
            bottom: 280,
            left: 150,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ArScreenSeven()));
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(
                  -3.1415926535897932 / 5,
                ),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(
                    -3.1415926535897932 / 3,
                  ),
                  child: Image.asset(
                    "images/arrow-right.png",
                    height: 80,
                    width: 80,
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
