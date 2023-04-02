import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/customer_model.dart';
import 'package:real_estate/model/property_model.dart';
import 'package:real_estate/screens/admin/agent_details.dart';

import '../../apis/api.dart';
import '../../main.dart';

class AssignedCustomers extends StatefulWidget {
  const AssignedCustomers({
    super.key,
    required this.property,
    required this.agent,
  });
  final Property property;
  final AgentModel agent;
  @override
  State<AssignedCustomers> createState() => _AssignedCustomersState();
}

class _AssignedCustomersState extends State<AssignedCustomers> {
  @override
  Widget build(BuildContext context) {
    log("${widget.property.id}");
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
                  "Customer Details",
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
            stream: APIs.getAssignedCustomers(widget.agent, widget.property),
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
                      height: mq.height - 160,
                      width: mq.width,
                      child: ListView.builder(
                          itemCount: _customerList.length,
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
                                    title: Text(
                                        _customerList[index].customer_name),
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
                                              color: _customerList[index].isLoan
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        )),
                                    trailing: Container(
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
    ));
  }
}
