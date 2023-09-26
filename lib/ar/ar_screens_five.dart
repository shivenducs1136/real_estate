import 'package:flutter/material.dart';

import '../main.dart';
import 'ar_screens_six.dart';

class ArScreenFive extends StatelessWidget {
  const ArScreenFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/5.jpg'), fit: BoxFit.fill)),
        child: Stack(children: [
          Positioned(
            bottom: 280,
            left: 150,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ArScreenSix()));
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(
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
        ]),
      ),
    );
  }
}
