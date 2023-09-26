import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/helper/widgets/control_panel.dart';
import 'package:real_estate/helper/widgets/recent_activity.dart';
import 'package:real_estate/model/activity_model.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/property_model.dart';
import 'package:real_estate/screens/admin/all_recent_activity.dart';
import 'package:real_estate/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // header row
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header Text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Propmart",
                        style: TextStyle(
                            color: Color.fromARGB(255, 25, 88, 103),
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      Text(
                        "Dashboard",
                        style: TextStyle(
                            color: Color.fromARGB(255, 242, 105, 35),
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  // Company Logo
                  InkWell(
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
                    child: const CircleAvatar(
                      radius: 24,
                      foregroundImage: AssetImage("images/company_logo.jpeg"),
                    ),
                  )
                ],
              ),
            ),

            // Control panel text
            Positioned(
                top: 100,
                left: 20,
                right: 20,
                bottom: 20,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Text(
                      "Control Panel",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ControlPanelWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Activity",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => RecentActivityScreen()));
                            },
                            child: const Text("View All"))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                        stream: APIs.getActivity(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const Center(
                                child: Text("No data"),
                              );
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data!.docs;

                              List<ActivityModel> mlist = data
                                      ?.map((e) =>
                                          ActivityModel.fromJson(e.data()))
                                      .toList() ??
                                  [];

                              mlist = mlist.reversed.toList();
                              return RecentActivityWidget(
                                  activityList: mlist, isAll: false);
                          }
                        })
                  ],
                )),
          ],
        ),
        persistentFooterButtons: [
          Center(
              child: Text(
                  "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
        ],
      ),
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
