import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:real_estate/screens/auth/login.dart';

import '../../helper/credentials.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: const [
        Center(
            child: Text(
                "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
      ],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 0, left: 30),
              child: Text(
                "Welcome 👋",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Lottie.asset(
                'images/login1.json',
                width: MediaQuery.of(context).size.height * .4,
                height: MediaQuery.of(context).size.height * .4,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, top: 10),
              child: Text(
                "Choose your login option and login with the provided password.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(150, 0, 0, 0),
                ),
                maxLines: 2,
                overflow: TextOverflow.fade,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .7,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginMain(
                                          mtitle: "Admin Login",
                                          isAdmin: true,
                                        )));
                          },
                          child: const Center(
                              child: Text(
                            "Admin",
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                        Container(
                          width: 1,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginMain(
                                        mtitle: "Agent Login",
                                        isAdmin: false)));
                          },
                          child: const Center(
                              child: Text(
                            "Agent",
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
