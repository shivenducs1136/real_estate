import 'package:flutter/material.dart';
import 'package:real_estate/screens/admin/add_agent.dart';
import 'package:real_estate/screens/admin/add_property.dart';
import 'package:real_estate/screens/admin/all_agent_screen.dart';
import 'package:real_estate/screens/admin/all_customers.dart';
import 'package:real_estate/screens/admin/assign_property.dart';
import 'package:real_estate/screens/admin/assigned_properties.dart';
import 'package:real_estate/screens/admin/choose_agent.dart';
import 'package:real_estate/screens/admin/loan_screen.dart';
import 'package:real_estate/screens/admin/purchase.dart';
import 'package:real_estate/screens/admin/rent.dart';
import 'package:real_estate/screens/admin/view_property.dart';
import 'package:real_estate/screens/admin/view_property.dart';

class ControlPanelWidget extends StatefulWidget {
  const ControlPanelWidget({super.key});

  @override
  State<ControlPanelWidget> createState() => _ControlPanelWidgetState();
}

class _ControlPanelWidgetState extends State<ControlPanelWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddPropertyScreen(
                              currProp: null, isUpdate: false)));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/property.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Property",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Add Property",
                                style: TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              AddAgentScreen(isUpdate: false, agent: null)));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/agent.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Agent   ",
                                style: TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Add Agent   ",
                                style: TextStyle(
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ViewPropertyScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/mproperty.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "My Property",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "View Property",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AllAgentScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/magents.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "My Agent",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "View Agents",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AllCustomersScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/mcustomers.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Customers",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "My Customers",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LoanScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/loan.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Loan",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Interested Customers",
                                maxLines: 1,
                                style: TextStyle(
                                    overflow: TextOverflow.clip,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AssignPropertyScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/delegation.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Assign",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Assign property",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ChooseAgentScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/location.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Location",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Track Agents",
                                maxLines: 1,
                                style: TextStyle(
                                    overflow: TextOverflow.clip,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PurchaseScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/order.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Purchase",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Want to purchase",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => RentScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 69, 69, 69),
                          offset: Offset.zero,
                          blurRadius: 0.1,
                          spreadRadius: 0.1)
                    ],
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset("images/rent.png")),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Renting",
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Want to rent",
                                maxLines: 1,
                                style: TextStyle(
                                    overflow: TextOverflow.clip,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
