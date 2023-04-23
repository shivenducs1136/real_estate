import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/model/mailer.dart';
import 'package:real_estate/screens/admin/admin_screen.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:real_estate/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class LoginMain extends StatefulWidget {
  const LoginMain({super.key, required this.mtitle, required this.isAdmin});
  final String mtitle;
  final bool isAdmin;
  @override
  State<LoginMain> createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  String email = "";
  String password = "";

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        persistentFooterButtons: const [
          Center(
              child: Text(
                  "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
        ],
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ignore: prefer_const_constructors
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      // ignore: prefer_const_constructors
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    SizedBox(
                      height: mq.width * .1,
                    ),
                    Text(
                      widget.mtitle,
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: mq.width * .1,
                    ),
                    TextFormField(
                      onChanged: (value) => email = value,
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        // ignore: prefer_const_constructors
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'eg. xyz@gmail.com',
                        label: const Text("Email Id"),
                      ),
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * 0.03,
                    ),
                    TextFormField(
                      onChanged: (value) => password = value,
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'eg. 1234!',
                        label: const Text("Password"),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * 0.03,
                    ),

                    Visibility(
                      visible: !widget.isAdmin,
                      child: InkWell(
                        onTap: () {
                          String em = email.trim().toString();
                          if (em.isNotEmpty && em.contains("@")) {
                            Dialogs.showProgressBar(context);
                            APIs.isAgentExists(em).then((isAgentExist) {
                              if (isAgentExist) {
                                var value = new Random();
                                var codeNumber =
                                    (value.nextInt(900000) + 100000).toString();
                                try {
                                  Mailer.sendCredentialsEmail(
                                      password: codeNumber, destEmail: em);
                                  APIs.updateEmailAndPassword(em, codeNumber)
                                      .then((value) {
                                    Navigator.pop(context);
                                    Dialogs.showSnackbar(context,
                                        "New password is sent to ${em}");
                                  });
                                } catch (e) {
                                  Navigator.pop(context);
                                  Dialogs.showSnackbar(
                                      context, "Unknown error occured");
                                }
                              } else {
                                Navigator.pop(context);
                                Dialogs.showSnackbar(
                                    context, "Please enter a valid email id.");
                              }
                            });
                          } else {
                            Dialogs.showSnackbar(
                                context, "Please enter a valid email id.");
                          }
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Dialogs.showProgressBar(context);
                  if (widget.isAdmin) {
                    Navigator.pop(context);
                    String em = email.trim().toString();
                    String pa = password.trim().toString();
                    if (APIs.adminLogin(em, pa)) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AdminScreen()));
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('login', 1);
                    } else {
                      Navigator.pop(context);
                      Dialogs.showSnackbar(context, "Login Failed");
                    }
                  } else {
                    await APIs.agentLogin(
                            email.trim().toString(), password.trim().toString())
                        .then((value) async {
                      if (value) {
                        Navigator.pop(context);
                        await APIs.activityLogin(email.trim().toString(),
                            "Agent - ${email.trim().toString()} Logged in");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AgentScreen(
                                      email: email,
                                    )));
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('login', 2);
                        await prefs.setString('email', email);
                      } else {
                        Navigator.pop(context);
                        Dialogs.showSnackbar(context, "Login Failed");
                      }
                    });
                  }
                },
                // ignore: prefer_const_constructors
                icon: Icon(
                  Icons.login,
                  size: 28,
                ),
                // ignore: prefer_const_constructors
                label: Text(
                  'Login',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: Size(mq.width * .5, mq.height * .06)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
