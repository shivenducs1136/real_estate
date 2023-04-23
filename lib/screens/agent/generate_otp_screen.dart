import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/apis/otp_authentication.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/model/customer_model.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../helper/credentials.dart';
import '../../main.dart';

String clientid = "";

class GenerateOtpScreenVerify extends StatefulWidget {
  const GenerateOtpScreenVerify({
    super.key,
    required this.customerModel,
  });
  final CustomerModel customerModel;

  @override
  State<GenerateOtpScreenVerify> createState() =>
      _GenerateOtpScreenVerifyState();
}

class _GenerateOtpScreenVerifyState extends State<GenerateOtpScreenVerify> {
  String verificationId = "";
  List<String> pin = [];
  String btnText = "SEND OTP";
  bool isTrackingStarted = false;
  @override
  Widget build(BuildContext context) {
    clientid = widget.customerModel.customer_id;
    return SafeArea(
        child: Scaffold(
      persistentFooterButtons: const [
        Center(
            child: Text(
                "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
      ],
      resizeToAvoidBottomInset: false,
      body: Container(
        height: mq.height,
        width: mq.width,
        child: Stack(children: [
          Positioned(
            top: 20,
            left: 20,
            child: InkWell(
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
            child: InkWell(
              onTap: () async {
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // Dialogs.showSnackbar(context, "Enabled Background processing");
                // await initializeService();
                // prefs.setBool('isTracking', true);
              },
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
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: ListTile(
              title: Text("${widget.customerModel.customer_name}"),
              subtitle: Text("+91 ${widget.customerModel.phonenumber}"),
              leading: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(),
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(24),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(
                        Icons.circle,
                        color: widget.customerModel.isLoan
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  )),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: InkWell(
              onTap: () {
                Dialogs.showProgressBar(context);
                _handleLocationPermission().then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  Navigator.pop(context);

                  await OtpAuth.sendOtp(
                      widget.customerModel.phonenumber, context);
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
              child: Consumer<AgentProvider>(builder: (context, mvalue, child) {
                return OtpTextField(
                  numberOfFields: 6,
                  borderColor: Color(0xFF512DA8),
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    Dialogs.showProgressBar(context);
                    OtpAuth.verifyOtp(verificationCode, context)
                        .then((value) async {
                      Navigator.pop(context);
                      if (value == 1) {
                        Dialogs.showSnackbar(
                            context, "User Verified Successfully");

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("isTracking", true);
                        prefs.setString("agentId", mvalue.getAgent!.id);
                        prefs.setString(
                            "customerId", mvalue.getCustomer!.customer_id);
                        prefs.setString("propertyId", mvalue.getProperty!.id);
                        Workmanager().registerPeriodicTask(
                            "location", "fetchlocation",
                            frequency: Duration(minutes: 15),
                            constraints:
                                Constraints(networkType: NetworkType.connected),
                            inputData: {
                              "agentId": mvalue.getAgent!.id,
                              "customerId": mvalue.getCustomer!.customer_id,
                              "propertyId": mvalue.getProperty!.id
                            });
                        mvalue.setTracking();
                        APIs.activityGenerateOtp(
                            property_id: mvalue.getProperty!.id,
                            msg:
                                "Agent - ${mvalue.getAgent!.agent_name} is with Customer - ${mvalue.getCustomer!.customer_name} going for Property - ${mvalue.getProperty!.property_name}",
                            agent_id: mvalue.getAgent!.id,
                            customer_id: mvalue.getCustomer!.customer_name);
                      } else if (value == -1) {
                        Dialogs.showSnackbar(
                            context, "User verification failed");
                        Navigator.pop(context);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("isTracking", false);
                        APIs.activityGenerateOtp(
                            property_id: mvalue.getProperty!.id,
                            msg:
                                "Agent - ${mvalue.getAgent!.agent_name} is with Customer - ${mvalue.getCustomer!.customer_name} have tried to verify customer.",
                            agent_id: mvalue.getAgent!.id,
                            customer_id: mvalue.getCustomer!.customer_name);
                      }
                    });
                  }, // end onSubmit
                );
              })),
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
