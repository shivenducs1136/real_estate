import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:real_estate/apis/otp_authentication.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/model/customer_model.dart';
import 'package:real_estate/screens/common/background_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

String clientid = "";

class GenerateOtpScreenVerify extends StatefulWidget {
  const GenerateOtpScreenVerify({super.key, required this.customerModel});
  final CustomerModel customerModel;
  @override
  State<GenerateOtpScreenVerify> createState() =>
      _GenerateOtpScreenVerifyState();
}

class _GenerateOtpScreenVerifyState extends State<GenerateOtpScreenVerify> {
  String verificationId = "";
  String btnText = "SEND OTP";
  var otpController = List.generate(6, (index) => TextEditingController());
  var isOtpSent = false;
  @override
  Widget build(BuildContext context) {
    clientid = widget.customerModel.customer_id;
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: mq.height,
        width: mq.width,
        child: Stack(children: [
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 26,
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
                    "Verify Client",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: ListTile(
              title: Text("${widget.customerModel.customer_name}"),
              subtitle: Text("+91 ${widget.customerModel.phonenumber}"),
              leading: const Icon(
                Icons.account_circle_outlined,
                size: 36,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                // Dialogs.showProgressBar(context);

                _handleLocationPermission().then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('agentId', widget.customerModel.agent_id);
                  prefs.setString(
                      'customerId', widget.customerModel.customer_id);
                  prefs.setString(
                      'propertyId', widget.customerModel.property_id);
                  // await initializeService();
                  OtpAuth.sendOtp(widget.customerModel.phonenumber)
                      .then((value) {
                    setState(() {
                      btnText = "RESEND OTP";
                    });
                  });
                });
              },
              child: Container(
                height: 80,
                width: mq.width * .7,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(14)),
                child: Center(
                    child: Text(
                  btnText,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500),
                )),
              ),
            ),
          ),
          Positioned(
              top: 200,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    6,
                    (index) => SizedBox(
                          width: 56,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: TextField(
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                controller: otpController[index],
                                cursorColor: Colors.red,
                                onChanged: (value) {
                                  if (value.length == 1 && index <= 5) {
                                    FocusScope.of(context).nextFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    hintText: "*")),
                          ),
                        )),
              )),
        ]),
      ),
    ));
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
