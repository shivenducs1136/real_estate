import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/agent/agent_choose_property.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:real_estate/screens/agent/generate_otp.dart';
import 'package:real_estate/screens/agent/location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitReviewWidget extends StatelessWidget {
  const SubmitReviewWidget({
    Key? key,
    required this.magent,
    required this.prefs,
  }) : super(key: key);
  final AgentModel magent;
  final SharedPreferences? prefs;
  @override
  Widget build(BuildContext context) {
    return Consumer<AgentProvider>(builder: (context, mvalue, child) {
      // if (prefs != null) {
      //   bool isTracking = prefs!.getBool("isTracking") ?? false;
      //   if (isTracking) {
      //     String propertyId = prefs!.getString("propertyId").toString() ?? "";
      //     String customerId = prefs!.getString("customerId").toString() ?? "";
      //     APIs.getPropertyByPropertyId(propertyId).then((preperty) {
      //       if (preperty != null) {
      //         mvalue.setProperty(preperty);
      //       }
      //       APIs.getCustomerById(customerId).then((customer) {
      //         if (customer != null) {
      //           mvalue.setCustomer(customer);
      //         }
      //       });
      //     });
      //   }
      // }

      return InkWell(
        onTap: () {
          mvalue.setAgent(magent);
          if (mvalue.trackingInfo) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AgentLocationScreen(
                          myCustomerModel: mvalue.getCustomer,
                        )));
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: mvalue.trackingInfo ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(
                  Icons.reviews,
                  size: 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Submit Review",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Submit Review of Customer & stop tracking.",
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.white),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
