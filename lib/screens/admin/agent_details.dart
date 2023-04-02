import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/screens/admin/add_agent.dart';
import 'package:real_estate/screens/common/assigned_customer.dart';

import '../../main.dart';
import '../../model/property_model.dart';

class AgentDetails extends StatefulWidget {
  const AgentDetails({super.key, required this.curr_agent});
  final AgentModel curr_agent;

  @override
  State<AgentDetails> createState() => _AgentDetailsState();
}

class _AgentDetailsState extends State<AgentDetails> {
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
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            // ignore: prefer_const_literals_to_create_immutables

            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
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
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Agent Details",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddAgentScreen(
                                      isUpdate: true,
                                      agent: widget.curr_agent,
                                    )));
                      },
                      child: const Icon(Icons.edit_document))
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: mq.width,
                height: mq.height * .1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(width: 1, color: Colors.black),
                    color: Color.fromARGB(222, 255, 255, 255)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Positioned(
                          child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(widget.curr_agent.photo),
                      )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 18,
                            width: mq.width * .6,
                            child: Text(
                              widget.curr_agent.agent_name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${widget.curr_agent.age} years",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            maxLines: 1,
                          ),
                          Container(
                            height: 14,
                            width: mq.width * .6,
                            child: Text(
                              "at ${widget.curr_agent.address}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Assigned Properties",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              mlist.length != 0
                  ? Container(
                      height: mq.height * .5,
                      child: GridView.builder(
                          itemCount: mlist!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (mq.height / mq.width) * .33,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: ((context, index) =>
                              propertyItem(mlist![index]))))
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
    return GestureDetector(
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
                child: Image.network(
                  property.showImg,
                  fit: BoxFit.cover,
                ),
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
