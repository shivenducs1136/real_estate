import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/helper/widgets/interested_cust.dart';
import 'package:real_estate/helper/widgets/near_to_customer.dart';
import 'package:real_estate/helper/widgets/nearby_places.dart';
import 'package:real_estate/helper/widgets/recommended_places.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/screens/admin/add_agent.dart';
import 'package:real_estate/screens/common/assigned_customer.dart';

import '../../helper/credentials.dart';
import '../../main.dart';
import '../../model/property_model.dart';

class ChooseProperties extends StatefulWidget {
  const ChooseProperties({super.key, required this.curr_agent});
  final AgentModel curr_agent;

  @override
  State<ChooseProperties> createState() => _ChoosePropertiesState();
}

class _ChoosePropertiesState extends State<ChooseProperties> {
  List<Property> mlist = [];
  @override
  void initState() {
    APIs.getMyAssignedPropertyofAgent(widget.curr_agent).then((value) {
      setState(() {
        mlist = value;
        log(mlist.toString());
      });
    });
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
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            // ignore: prefer_const_literals_to_create_immutables

            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
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
                      "Choose Property",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              mlist.length != 0
                  ? NeartoCustomer(
                      nearbyPlaces: mlist,
                      isUpdate: true,
                      email: widget.curr_agent.email,
                    )
                  : Center(
                      child: Lottie.asset(
                      'images/nodata.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ))
            ]),
          ),
        ),
      ),
    );
  }
}
