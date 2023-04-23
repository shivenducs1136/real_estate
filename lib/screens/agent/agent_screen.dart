import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/helper/widgets/submit_review.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/admin/all_customers.dart';
import 'package:real_estate/screens/admin/assigned_properties.dart';
import 'package:real_estate/screens/agent/agent_assigned_properties.dart';
import 'package:real_estate/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/widgets/location_card.dart';
import '../../helper/widgets/nearby_places.dart';
import '../../helper/widgets/recommended_places.dart';
import '../../model/property_model.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<AgentScreen> createState() => AgentScreenState();
}

class AgentScreenState extends State<AgentScreen> {
  List<Property>? mylist;
  SharedPreferences? prefs;
  AgentModel magent = AgentModel(
      agent_name: "",
      age: "",
      phone_number: "",
      address: "",
      id: "",
      photo: "",
      email: "",
      password: "",
      dob: "",
      isMale: false);
  List<Property>? allProperty;
  @override
  void initState() {
    APIs.getSpecificAgentDetail(widget.email).then((value) async {
      if (value == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
      prefs = await SharedPreferences.getInstance();
      magent = value!;

      await APIs.getAssignedPropertyofAgents(magent).then((data) {
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
            child: InkWell(
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
          LocationCard(magent: magent),
          const SizedBox(
            height: 15,
          ),
          SubmitReviewWidget(magent: magent, prefs: prefs),
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
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AgentAssignedProperties(
                                  curr_agent: magent,
                                )));
                  },
                  child: const Text("View All"))
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
      persistentFooterButtons: const [
        Center(
            child: Text(
                "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
      ],
    );
  }

  Future<void> onConfirm() async {
    await APIs.activityLogout(
        widget.email, "Agent - ${magent.agent_name} Logged out");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('login', 0);
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.delete();
    }
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
