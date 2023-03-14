import 'package:flutter/material.dart';
import 'package:real_estate/screens/auth/login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginMain(
                              mtitle: "Admin Login", isAdmin: true)));
                },
                child: const Text(
                  "Admin",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginMain(
                              mtitle: "Agent Login", isAdmin: false)));
                },
                child: const Text(
                  "Agent",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
            ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Client",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
