import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/model/agent_model.dart';

import '../../main.dart';

class AllAgentScreen extends StatefulWidget {
  const AllAgentScreen({super.key});

  @override
  State<AllAgentScreen> createState() => _AllAgentScreenState();
}

class _AllAgentScreenState extends State<AllAgentScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
        StreamBuilder(
            stream: APIs.getAllAgents(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return SizedBox();
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  List<AgentModel> _agentlist = data
                          ?.map((e) => AgentModel.fromJson(e.data()))
                          .toList() ??
                      [];
                  if (_agentlist.isNotEmpty) {
                    return Container(
                      height: mq.height - 160,
                      width: mq.width,
                      child: ListView.builder(
                          itemCount: _agentlist.length,
                          itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: Container(
                                  height: 80,
                                  width: mq.width * .8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 1, color: Colors.black),
                                  ),
                                  child: ListTile(
                                    title:
                                        Text("${_agentlist[index].agent_name}"),
                                    subtitle:
                                        Text("${_agentlist[index].email}"),
                                    leading: Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(),
                                        child: ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Image.network(
                                                _agentlist[index].photo),
                                          ),
                                        )),
                                  ),
                                ),
                              )),
                    );
                  } else {
                    return Center(
                      child: Text("No data"),
                    );
                  }
              }
            })
      ]),
    ));
  }
}