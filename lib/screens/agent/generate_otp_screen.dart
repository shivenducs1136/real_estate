import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:real_estate/apis/otp_authentication.dart';
import 'package:real_estate/model/customer_model.dart';

import '../../main.dart';

class GenerateOtpScreenVerify extends StatefulWidget {
  const GenerateOtpScreenVerify({super.key, required this.customerModel});
  final CustomerModel customerModel;
  @override
  State<GenerateOtpScreenVerify> createState() =>
      _GenerateOtpScreenVerifyState();
}

class _GenerateOtpScreenVerifyState extends State<GenerateOtpScreenVerify> {
  String verificationId = "";

  @override
  Widget build(BuildContext context) {
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
                    "Generate OTP",
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
            top: 100,
            left: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                OtpAuth.sendOtp(widget.customerModel.phonenumber);
              },
              child: Container(
                height: 80,
                width: mq.width * .7,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(14)),
                child: const Center(
                    child: Text(
                  "SEND OTP",
                  style: TextStyle(
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
            child: OTPTextField(
              length: 6,
              width: MediaQuery.of(context).size.width * .6,
              fieldWidth: 60,
              style: TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) async {
                OtpAuth.verifyOtp(pin);
              },
            ),
          ),
        ]),
      ),
    ));
  }
}
