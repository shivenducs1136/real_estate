import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/helper/widgets/choose_agent_nearbyplaces.dart';
import 'package:real_estate/helper/widgets/interested_cust.dart';
import 'package:real_estate/helper/widgets/near_to_customer.dart';
import 'package:real_estate/helper/widgets/nearby_places.dart';
import 'package:real_estate/helper/widgets/recommended_places.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/admin/add_agent.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:real_estate/screens/common/assigned_customer.dart';

import '../../helper/credentials.dart';
import '../../main.dart';
import '../../model/property_model.dart';

class ChooseAgentProperties extends StatefulWidget {
  const ChooseAgentProperties({super.key, required this.curr_agent});
  final AgentModel curr_agent;

  @override
  State<ChooseAgentProperties> createState() => _ChooseAgentPropertiesState();
}

class _ChooseAgentPropertiesState extends State<ChooseAgentProperties> {
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
        persistentFooterButtons: [
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
                  ? Container(
                      height: mq.height * .5,
                      child: ChooseAgentNearbyPlaces(
                        nearbyPlaces: mlist,
                        isUpdate: true,
                        email: widget.curr_agent.email,
                        agentModel: widget.curr_agent,
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

  Widget propertyItem(Property property) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AssignedCustomers(
                    property: property, agent: widget.curr_agent)));
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Dialogs.showImage(property.showImg),
              ),
            ),
            SizedBox(height: 8),
            Text(
              property.property_name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              property.address,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text('\$${property.cost.toString()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ))
          ]),
        ),
      ),
    );
  }
}
