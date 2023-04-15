import 'package:flutter/material.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/model/customer_model.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:real_estate/screens/agent/generate_otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/credentials.dart';
import '../../main.dart';

class GenerateOtpScreen extends StatefulWidget {
  const GenerateOtpScreen({super.key});

  @override
  State<GenerateOtpScreen> createState() => _GenerateOtpScreenState();
}

class _GenerateOtpScreenState extends State<GenerateOtpScreen> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final prefs = await SharedPreferences.getInstance();
        final String email = prefs.getString('email') ?? '';
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => AgentScreen(email: email)));
        return true;
      },
      child: SafeArea(
          child: Scaffold(
        persistentFooterButtons: [
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
                      "Select Customer",
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
              top: 70,
              left: 10,
              right: 10,
              bottom: 10,
              child: Container(
                color: Colors.transparent,
                child: StreamBuilder(
                  stream: APIs.getAllCustomers(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        List<CustomerModel> myCustomer = data
                                ?.map((e) => CustomerModel.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (myCustomer.isNotEmpty) {
                          return Expanded(
                              child: ListView.builder(
                                  itemCount: myCustomer.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      GenerateOtpScreenVerify(
                                                        customerModel:
                                                            myCustomer[index],
                                                      )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          child: Container(
                                            height: 80,
                                            width: mq.width * .8,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black),
                                            ),
                                            child: ListTile(
                                              title: Text(myCustomer[index]
                                                  .customer_name),
                                              subtitle: Text(
                                                myCustomer[index].phonenumber,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )));
                        } else {
                          return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.blue),
                          );
                        }
                    }
                  },
                ),
              ),
            )
          ]),
        ),
      )),
    );
  }
}
