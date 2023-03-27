import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/property_model.dart';
import 'package:real_estate/screens/admin/add_agent.dart';
import 'package:real_estate/screens/admin/add_property.dart';
import 'package:real_estate/screens/admin/agent_details.dart';
import 'package:real_estate/screens/admin/assign_property.dart';
import 'package:real_estate/screens/admin/view_property.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';

import '../../main.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<AgentModel> _agentlist = [];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Property p = Property(
        property_name: "",
        bedrooms: "",
        bathrooms: "",
        garages: "",
        cost: "",
        area: "",
        id: "",
        address: "",
        lat: "",
        lon: "",
        showImg: "",
        yearBuilt: "");
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Dashboard",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () => {},
                  child: Icon(Icons.menu),
                )
              ]),
              SizedBox(
                height: mq.height * .05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddPropertyScreen(
                                    currProp: p,
                                    isUpdate: false,
                                  )));
                    },
                    child: Container(
                      height: 100,
                      width: mq.width * .2,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(250, 218, 229, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add_home_outlined,
                            color: Color.fromRGBO(251, 67, 131, 1),
                            size: 30,
                          ),
                          Text(
                            "Add Property",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(251, 67, 131, 1),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AddAgentScreen()));
                    },
                    child: Container(
                      height: 100,
                      width: mq.width * .2,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(196, 221, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.account_circle_outlined,
                            color: Color.fromRGBO(45, 131, 251, 1),
                            size: 30,
                          ),
                          Text(
                            "Add \n Agents",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(45, 131, 251, 1),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ViewPropertyScreen()));
                    },
                    child: Container(
                      height: 100,
                      width: mq.width * .2,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(211, 255, 217, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.home_outlined,
                            color: Color.fromRGBO(3, 166, 25, 1),
                            size: 30,
                          ),
                          Text(
                            "My \n Property",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(3, 166, 25, 1),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AssignPropertyScreen()));
                    },
                    child: Container(
                      height: 100,
                      width: mq.width * .2,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 211, 203, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.local_post_office_outlined,
                            color: Color.fromRGBO(247, 37, 0, 1),
                            size: 30,
                          ),
                          Text(
                            "Assign \n Property",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(247, 37, 0, 1),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: mq.height * .04,
              ),
              const Text(
                "My Agents",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              SizedBox(
                height: mq.height * .15,
                width: mq.width,
                child: StreamBuilder(
                  stream: APIs.getAllAgents(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _agentlist = data
                                ?.map((e) => AgentModel.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (_agentlist.isNotEmpty) {
                          return Container(
                              height: mq.height,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _agentlist.length,
                                  itemBuilder: ((context, index) =>
                                      agentChip(_agentlist[index]))));
                        } else {
                          return agentChip(AgentModel(
                              agent_name: "Sample Name",
                              age: "0",
                              phone_number: "0000000000",
                              address: "Sample Address",
                              id: "1",
                              photo:
                                  "https://th.bing.com/th/id/OIP.tWwHa21PC-F18kRm0I2w7wHaHa?pid=ImgDet&rs=1"));
                        }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget agentChip(AgentModel a) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => AgentDetails(curr_agent: a)));
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(a.photo),
                ),
                SizedBox(height: 8),
                Text(
                  '${a.agent_name}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chip(Color mcolor, Color iconcolor, Icon micon, String txt, int type) {
    return InkWell(
      onTap: () {
        if (type == 1) {
          Property p = Property(
              property_name: "",
              bedrooms: "",
              bathrooms: "",
              garages: "",
              cost: "",
              area: "",
              id: "",
              address: "",
              lat: "",
              lon: "",
              showImg: "",
              yearBuilt: "");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddPropertyScreen(
                        currProp: p,
                        isUpdate: false,
                      )));
        } else if (type == 2) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddAgentScreen()));
        } else if (type == 3) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ViewPropertyScreen()));
        } else if (type == 4) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AssignPropertyScreen()));
        }
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: mq.height * .13,
          width: mq.width * .2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: mcolor),
          child: Stack(
            children: [
              Positioned(top: 20, left: 20, right: 20, child: micon),
              Positioned(
                bottom: 20,
                left: 10,
                right: 10,
                child: Text(
                  txt,
                  style: TextStyle(
                      color: iconcolor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
