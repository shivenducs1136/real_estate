import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/agent/agent_choose_property.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:real_estate/screens/agent/generate_otp.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({Key? key, required this.magent}) : super(key: key);
  final AgentModel magent;

  @override
  Widget build(BuildContext context) {
    return Consumer<AgentProvider>(
      builder: (context, value, child) {
        return InkWell(
          onTap: () {
            value.setAgent(magent);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChooseAgentProperties(curr_agent: magent)));
          },
          child: Card(
            elevation: 0.4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(
                    Icons.domain_verification,
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Generate OTP",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Verify customer & start tracking.",
                        style: Theme.of(context).textTheme.labelSmall,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
