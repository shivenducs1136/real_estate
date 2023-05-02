import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/customer_model.dart';
import 'package:real_estate/model/property_model.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/admin/interested_customer_screen.dart';
import 'package:real_estate/screens/admin/interested_properties.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:real_estate/screens/agent/customer_property.dart';
import 'package:real_estate/screens/agent/generate_otp_screen.dart';
import 'package:real_estate/screens/common/polyline_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/credentials.dart';
import '../../main.dart';

class GenerateOtpScreen extends StatefulWidget {
  const GenerateOtpScreen({
    super.key,
    required this.agentModel,
    required this.propertyModel,
  });
  final AgentModel agentModel;
  final Property propertyModel;

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
          body: Column(children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "Select Customer",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    child: Container(
                        height: 48,
                        width: 48,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(14)),
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset("images/company_logo.jpeg"))),
                  )
                ],
              ),
            ),
            const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text("Choose the customer to verify.")),
            StreamBuilder(
                stream: APIs.getAssignedCustomers(
                    widget.agentModel, widget.propertyModel),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return SizedBox();
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      List<CustomerModel> _customerList = data
                              ?.map((e) => CustomerModel.fromJson(e.data()))
                              .toList() ??
                          [];
                      if (_customerList.isNotEmpty) {
                        return Container(
                          height: mq.height - 250,
                          width: mq.width,
                          child: ListView.builder(
                              itemCount: _customerList.length,
                              itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 10),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    GenerateOtpScreenVerify(
                                                      customerModel:
                                                          _customerList[index],
                                                    )));
                                      },
                                      child: Container(
                                        height: 80,
                                        width: mq.width * .8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 1, color: Colors.black),
                                        ),
                                        child: ListTile(
                                          title: Text(_customerList[index]
                                              .customer_name),
                                          subtitle: Text(
                                            _customerList[index].address,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          leading: Container(
                                              height: 24,
                                              width: 24,
                                              decoration: BoxDecoration(),
                                              child: ClipRRect(
                                                clipBehavior: Clip.hardEdge,
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: _customerList[index]
                                                            .isLoan
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                              )),
                                          trailing: InkWell(
                                            onTap: () {
                                              Dialogs.callNumber(
                                                  _customerList[index]
                                                      .phonenumber);
                                            },
                                            child: Container(
                                                height: 36,
                                                width: 36,
                                                decoration: BoxDecoration(),
                                                child: ClipRRect(
                                                  clipBehavior: Clip.hardEdge,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  child: const FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: Icon(Icons.call),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                        );
                      } else {
                        return const Center(
                          child: Text("No data"),
                        );
                      }
                  }
                })
          ]),
        )));
  }
}
