import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/widgets/custom_icon_button.dart';
import '../../helper/widgets/location_card.dart';
import '../../helper/widgets/nearby_places.dart';
import '../../helper/widgets/recommended_places.dart';
import '../../model/property_model.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  List<Property>? mylist;
  AgentModel magent = AgentModel(
      agent_name: "",
      age: "",
      phone_number: "",
      address: "",
      id: "",
      photo: "",
      email: "",
      password: "");
  List<Property>? allProperty;
  @override
  void initState() {
    APIs.getSpecificAgentDetail(widget.email).then((value) async {
      if (value == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
      magent = value!;
      await APIs.getAssignedPropertyofAgents(magent!).then((data) {
        setState(() {});
        mylist = data;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(magent!.agent_name),
            Text(
              magent!.email,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(magent.photo),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 12),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: onConfirm,
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    });
              },
              child: const SizedBox(
                height: 38,
                width: 38,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image(image: AssetImage('images/company_logo.jpeg')),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(14),
        children: [
          // LOCATION CARD
          const LocationCard(),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Assigned Properties",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(onPressed: () {}, child: const Text("View All"))
            ],
          ),
          const SizedBox(height: 10),
          mylist != null
              ? RecommendedPlaces(
                  recommendedPlaces: mylist!,
                  isUpdate: false,
                  email: widget.email,
                )
              : Center(child: CircularProgressIndicator()),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Properties",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(onPressed: () {}, child: const Text("View All"))
            ],
          ),
          const SizedBox(height: 10),
          StreamBuilder(
              stream: APIs.getAllProperties(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    allProperty = data
                            ?.map((e) => Property.fromJson(e.data()))
                            .toList() ??
                        [];
                    return NearbyPlaces(
                      nearbyPlaces: allProperty!,
                      isUpdate: false,
                      email: widget.email,
                    );
                }
              }),
        ],
      ),
      persistentFooterButtons: [
        Center(
            child: Text(
                "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
      ],
    );
  }

  Future<void> onConfirm() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('login', 0);
    Navigator.pop(context);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
