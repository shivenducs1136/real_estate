import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
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
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        persistentFooterButtons: [
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ignore: prefer_const_constructors
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoginScreen()));
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
                          onSaved: ((newValue) {
                            email = newValue!;
                            setState(() {});
                          }),
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
                          onSaved: ((newValue) {
                            password = newValue!;
                            setState(() {});
                          }),
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
                              formKey.currentState!.save();
                              String em = email.trim().toLowerCase().toString();
                              Dialogs.checkInternet().then((value) {
                                if (value) {
                                  if (em.isNotEmpty &&
                                      em.contains("@") &&
                                      em.contains(".com")) {
                                    Dialogs.showProgressBar(context);
                                    APIs.isAgentExists(em).then((isAgentExist) {
                                      if (isAgentExist) {
                                        var value = new Random();
                                        var codeNumber =
                                            (value.nextInt(900000) + 100000)
                                                .toString();
                                        try {
                                          Mailer.sendCredentialsEmail(
                                              password: codeNumber,
                                              destEmail: em);
                                          APIs.updateEmailAndPassword(
                                                  em, codeNumber)
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
                                        Dialogs.showSnackbar(context,
                                            "Please enter a valid email id.");
                                      }
                                    });
                                  } else {
                                    Dialogs.showSnackbar(context,
                                        "Please enter a valid email id.");
                                  }
                                } else {
                                  Dialogs.showSnackbar(
                                      context, "No Internet Connection");
                                }
                              });
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              ElevatedButton.icon(
                onPressed: () async {
                  formKey.currentState!.save();
                  FocusScope.of(context).requestFocus(FocusNode());
                  String em = email.trim().toLowerCase().toString();
                  String pa = password.trim().toString();
                  Dialogs.checkInternet().then((value) async {
                    if (value) {
                      Dialogs.showProgressBar(context);

                      if (widget.isAdmin) {
                        Navigator.pop(context);

                        if (APIs.adminLogin(em, pa)) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AdminScreen()));
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('login', 1);
                        } else {
                          Dialogs.showSnackbar(context, "Login Failed");
                        }
                      } else {
                        if (em.isNotEmpty &&
                            em.contains("@") &&
                            em.contains(".com")) {
                          await APIs.agentLogin(
                                  email.trim().toLowerCase().toString(),
                                  password.trim().toString())
                              .then((value) async {
                            if (value) {
                              Navigator.pop(context);
                              await APIs.activityLogin(
                                  email.trim().toLowerCase().toString(),
                                  "Agent - ${email.trim().toLowerCase().toString()} Logged in");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AgentScreen(
                                            email: email,
                                          )));
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setInt('login', 2);
                              await prefs.setString('email', email);
                            } else {
                              Navigator.pop(context);
                              Dialogs.showSnackbar(context, "Login Failed");
                            }
                          });
                        } else {
                          Navigator.pop(context);
                          Dialogs.showSnackbar(context,
                              "Valid email should contains `@` and `.com` ");
                        }
                      }
                    } else {
                      Dialogs.showSnackbar(context, "No Internet Connection");
                    }
                  });
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
