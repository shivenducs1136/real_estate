import 'dart:developer';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/model/agent_model.dart';

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
                  const Icon(Icons.edit_document)
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Card(
                child: Container(
                  width: mq.width,
                  height: mq.height * .1,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Positioned(
                            child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              NetworkImage(widget.curr_agent.photo),
                        )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.curr_agent.agent_name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                            Text(
                              "${widget.curr_agent.age} years",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                            ),
                            Text(
                              "at ${widget.curr_agent.address}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                            ),
                          ],
                        )
                      ],
                    ),
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
              StreamBuilder(
                  stream: Stream.fromFuture(
                      APIs.getAllAssignedProperties(widget.curr_agent)
                          .then((value) => value)),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        // final propertySnapshot = snapshot.data;
                        // mlist.add(Property.fromJson(propertySnapshot.data()));
                        return Container(
                            height: mq.height,
                            child: GridView.builder(
                                itemCount: mlist.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      (mq.height / mq.width) * .33,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: ((context, index) =>
                                    propertyItem(mlist[index]))));
                    }
                  }),
            ]),
          ),
        ),
      ),
    );
  }

  Widget propertyItem(Property p) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: mq.width * .4,
        height: mq.height * .27,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1.0)),
        child: Padding(
          padding: EdgeInsets.all(5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: mq.height * .17,
              width: mq.width * .4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: AssetImage("images/home.png"))),
              child:
                  FittedBox(fit: BoxFit.fill, child: Image.network(p.showImg)),
            ),
            SizedBox(
              height: mq.height * .007,
            ),
            Text(
              p.property_name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              textWidthBasis: TextWidthBasis.parent,
            ),
            Text(
              "${p.area} sq. ft.",
              style: TextStyle(color: Colors.black, fontSize: 12),
              maxLines: 1,
              textWidthBasis: TextWidthBasis.parent,
            ),
            SizedBox(
              height: mq.height * .01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹ ${p.cost}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  textWidthBasis: TextWidthBasis.parent,
                ),
                Icon(
                  Icons.edit,
                  size: 22,
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}