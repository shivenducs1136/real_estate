// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/cost_util.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/screens/admin/add_property.dart';
import 'package:real_estate/screens/admin/assigned_agents_screen.dart';
import 'package:real_estate/screens/admin/interested_customer_screen.dart';
import 'package:real_estate/screens/common/assigned_customer.dart';
import 'package:real_estate/screens/admin/assigned_agents_screen.dart';
import '../../model/property_model.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({
    Key? key,
    required this.mproperty,
    required this.isUpdate,
    required this.email,
  }) : super(key: key);
  final Property mproperty;
  final bool isUpdate;
  final String? email;
  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  AgentModel? magent;
  @override
  void initState() {
    if (widget.email != null && widget.email != "") {
      APIs.getSpecificAgentDetail(widget.email!).then((value) {
        if (value != null) {
          magent = value;
          setState(() {});
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      persistentFooterButtons: const [
        Center(
            child: Text(
                "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
      ],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            SizedBox(
              height: size.height * 0.38,
              width: double.maxFinite,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20)),
                      image: DecorationImage(
                        image: NetworkImage(widget.mproperty.showImg),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            iconSize: 20,
                            icon: const Icon(Ionicons.chevron_back),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mproperty.property_name,
                        maxLines: 1,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(height: 5),
                      Row(children: [
                        Icon(
                          Icons.place,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        Text(
                          widget.mproperty.address,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ])
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "₹ ${CostConverter.convertToIndianCurrencyFormat(int.parse(widget.mproperty.cost))}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Built in: ${widget.mproperty.yearBuilt}",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
                widget.isUpdate
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AssignedAgentsScreen(
                                        mproperty: widget.mproperty,
                                      )));
                        },
                        child: const Text(
                          "Assigned Agents",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : SizedBox(),
                widget.isUpdate
                    ? ElevatedButton(
                        onPressed: () {
                          APIs.getSpecificAgentDetail(widget.email.toString())
                              .then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => InterestedCustomerScreen(
                                          property: widget.mproperty,
                                          agentModel: value,
                                        )));
                          });
                        },
                        child: const Text(
                          "Clients",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(5),
              height: 180,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 2, color: Colors.black)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Area : ${widget.mproperty.area}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      Text("Garages: ${widget.mproperty.garages}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Bedrooms : ${widget.mproperty.bedrooms}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                      Text("Bathrooms: ${widget.mproperty.bathrooms}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.isUpdate
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AddPropertyScreen(
                                currProp: widget.mproperty, isUpdate: true)))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AssignedCustomers(
                                  agent: magent!,
                                  property: widget.mproperty,
                                )));
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 8.0,
                ),
              ),
              child: widget.isUpdate
                  ? const Text("Update Property Details")
                  : const Text("View Assigned Customers"),
            )
          ],
        ),
      ),
    );
  }
}
