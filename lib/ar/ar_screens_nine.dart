import 'package:flutter/material.dart';

import '../main.dart';

class ArScreenNine extends StatelessWidget {
  const ArScreenNine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/6.jpg'), fit: BoxFit.fill)),
        child: Stack(children: []),
      ),
    );
  }
}
