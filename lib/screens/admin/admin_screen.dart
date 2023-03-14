import 'package:flutter/material.dart';
import 'package:real_estate/screens/admin/add_agent.dart';
import 'package:real_estate/screens/admin/add_property.dart';
import 'package:real_estate/screens/admin/assign_property.dart';
import 'package:real_estate/screens/admin/view_property.dart';

import '../../main.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
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
                  chip(
                      Color.fromRGBO(250, 218, 229, 1),
                      Color.fromRGBO(251, 67, 131, 1),
                      Icon(
                        Icons.add_home_outlined,
                        color: Color.fromRGBO(251, 67, 131, 1),
                        size: 40,
                      ),
                      "Add Property",
                      1),
                  chip(
                      Color.fromRGBO(196, 221, 255, 1),
                      Color.fromRGBO(45, 131, 251, 1),
                      Icon(
                        Icons.account_circle_outlined,
                        color: Color.fromRGBO(45, 131, 251, 1),
                        size: 40,
                      ),
                      "Add Agents",
                      2),
                  chip(
                      Color.fromRGBO(211, 255, 217, 1),
                      Color.fromRGBO(3, 166, 25, 1),
                      Icon(
                        Icons.home_outlined,
                        color: Color.fromRGBO(3, 166, 25, 1),
                        size: 40,
                      ),
                      "My Property",
                      3),
                  chip(
                      Color.fromRGBO(255, 211, 203, 1),
                      Color.fromRGBO(247, 37, 0, 1),
                      Icon(
                        Icons.local_post_office_outlined,
                        color: Color.fromRGBO(247, 37, 0, 1),
                        size: 40,
                      ),
                      "Assign Property",
                      4),
                ],
              ),
              SizedBox(
                height: mq.height * .04,
              ),
              Text(
                "Updates",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget chip(Color mcolor, Color iconcolor, Icon micon, String txt, int type) {
    return InkWell(
      onTap: () {
        if (type == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddPropertyScreen()));
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
    );
  }
}
