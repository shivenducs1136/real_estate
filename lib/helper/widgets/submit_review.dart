import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/agent/agent_choose_property.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:real_estate/screens/agent/generate_otp.dart';
import 'package:real_estate/screens/agent/location_screen.dart';

class SubmitReviewWidget extends StatelessWidget {
  const SubmitReviewWidget({
    Key? key,
    required this.magent,
  }) : super(key: key);
  final AgentModel magent;

  @override
  Widget build(BuildContext context) {
    return Consumer<AgentProvider>(builder: (context, mvalue, child) {
      return Container(
        decoration: BoxDecoration(
            color: mvalue.trackingInfo ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(16)),
        child: GestureDetector(
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
