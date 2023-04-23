import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/customer_model.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class AgentLocationScreen extends StatefulWidget {
  const AgentLocationScreen({
    super.key,
    this.myCustomerModel,
  });
  final CustomerModel? myCustomerModel;

  @override
  State<AgentLocationScreen> createState() => Agent_LocationScreenState();
}

class Agent_LocationScreenState extends State<AgentLocationScreen> {
  bool isChecked = false;
  String reviewText = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final prefs = await SharedPreferences.getInstance();
          final String email = prefs.getString('email') ?? '';
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => AgentScreen(email: email)));
          return true;
        },
        child: SafeArea(
          child: Scaffold(
              persistentFooterButtons: const [
                Center(
                    child: Text(
                        "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
              ],
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: Container(
                      width: mq.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Location Tracking",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 180,
                      bottom: 100,
                      left: 20,
                      right: 20,
                      child: Container(
                          child: Column(
                        children: [
                          ListTile(
                            leading: Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            title: const Text(
                              "Would customer like to take loan in future?",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: mq.height * .15,
                            width: mq.width * 1,
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  reviewText = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              validator: (val) => val != null && val.isNotEmpty
                                  ? null
                                  : "Required Field",
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                hintText: "eg. I found this property very...",
                              ),
                              maxLines: 10,
                            ),
                          )
                        ],
                      ))),
                  Positioned(
                    top: 60,
                    left: 10,
                    right: 10,
                    child: ListTile(
                      title: Text(
                          widget.myCustomerModel!.customer_name.toString()),
                      subtitle: Text(widget.myCustomerModel!.phonenumber),
                      leading: const Icon(Icons.outlined_flag_outlined),
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Consumer<AgentProvider>(
                          builder: (context, mvalue, child) {
                        return InkWell(
                          onTap: () async {
                            Workmanager().cancelAll();
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setBool('isTracking', false);
                            APIs.submitReview(
                                widget.myCustomerModel!, reviewText);
                            APIs.setisLoan(widget.myCustomerModel!, isChecked);
                            mvalue.setTracking();
                            if (FirebaseAuth.instance.currentUser != null) {
                              FirebaseAuth.instance.currentUser!.delete();
                            }
                            Navigator.pop(context);
                            Dialogs.showSnackbar(
                                context, "Review Submitted Successfuly");
                          },
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                                child: Text(
                              "Submit Review",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            )),
                          ),
                        );
                      })),
                  const Positioned(
                      top: 140,
                      left: 20,
                      child: Text(
                        "Request a review.",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                ],
              )),
        ));
  }
}
// Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               Dialogs.showSnackbar(context, "Location Service Stopped");
//               FlutterBackgroundService().invoke('stopService');
//               SharedPreferences pref = await SharedPreferences.getInstance();
//               pref.setBool('isTracking', false);
//             },
//             child: Text("Stop Location Tracking"),
//           ),