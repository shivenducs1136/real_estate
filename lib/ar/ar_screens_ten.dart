import 'package:flutter/material.dart';
import 'package:real_estate/ar/ar_screens_eight.dart';
import 'package:real_estate/ar/ar_screens_eleven.dart';

import '../main.dart';

class ArScreenTen extends StatelessWidget {
  const ArScreenTen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/10.jpg'), fit: BoxFit.fill)),
        child: Stack(children: [
          Positioned(
            bottom: 280,
            left: 130,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ArScreenEleven()));
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(
                  -3.1415926535897932 / 3,
                ),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(
                    -3.1415926535897932 / 2,
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
