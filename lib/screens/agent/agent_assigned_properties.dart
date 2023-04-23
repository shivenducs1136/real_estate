import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/widgets/nearby_places.dart';
import 'package:real_estate/helper/widgets/recommended_places.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/screens/admin/add_agent.dart';
import 'package:real_estate/screens/common/assigned_customer.dart';

import '../../helper/credentials.dart';
import '../../main.dart';
import '../../model/property_model.dart';

class AgentAssignedProperties extends StatefulWidget {
  const AgentAssignedProperties({super.key, required this.curr_agent});
  final AgentModel curr_agent;

  @override
  State<AgentAssignedProperties> createState() =>
      _AgentAssignedPropertiesState();
}

class _AgentAssignedPropertiesState extends State<AgentAssignedProperties> {
  List<Property> mlist = [];
  @override
  void initState() {
    APIs.getAssignedPropertyofAgents(widget.curr_agent).then((value) {
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
                      "Assigned Properties",
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
                  ? Container(
                      height: mq.height * .5,
                      child: NearbyPlaces(
                        nearbyPlaces: mlist,
                        isUpdate: false,
                        email: widget.curr_agent.email,
                      ))
                  : Container(
                      height: mq.height * .5,
                      child: Center(
                          child: Lottie.asset(
                        'images/nodata.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      )),
                    )
            ]),
          ),
        ),
      ),
    );
  }
}
