import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/widgets/recent_activity.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/activity_model.dart';

import '../../helper/credentials.dart';

class RecentActivityScreen extends StatefulWidget {
  const RecentActivityScreen({super.key});

  @override
  State<RecentActivityScreen> createState() => _RecentActivityScreenState();
}

class _RecentActivityScreenState extends State<RecentActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      persistentFooterButtons: const [
        Center(
            child: Text(
                "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
      ],
      resizeToAvoidBottomInset: false,
      body: Container(
        height: mq.height,
        width: mq.width,
        child: Stack(children: [
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
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Recent Activities",
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
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            bottom: 10,
            left: 20,
            right: 20,
            child: SingleChildScrollView(
              child: StreamBuilder(
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
                                ?.map((e) => ActivityModel.fromJson(e.data()))
                                .toList() ??
                            [];

                        mlist = mlist.reversed.toList();
                        return RecentActivityWidget(
                            activityList: mlist, isAll: true);
                    }
                  }),
            ),
          )
        ]),
      ),
    ));
  }
}
