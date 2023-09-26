import 'package:flutter/material.dart';

import '../main.dart';

class ArScreenThree extends StatelessWidget {
  const ArScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/3.jpg'), fit: BoxFit.fill)),
        child: Stack(children: []),
      ),
    );
  }
}
