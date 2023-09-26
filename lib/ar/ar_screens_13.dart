import 'package:flutter/material.dart';
import 'package:real_estate/ar/ar_screens_eight.dart';
import '../main.dart';

class ArScreen13 extends StatelessWidget {
  const ArScreen13({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/13.jpg'), fit: BoxFit.fill)),
        child: Stack(children: []),
      ),
    );
  }
}
