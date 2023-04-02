import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/media.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/property_model.dart';
import 'package:real_estate/screens/admin/agent_details.dart';
import 'package:real_estate/screens/common/assigned_customer.dart';
import 'package:real_estate/screens/agent/generate_otp.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key, required this.email});
  final String email;
  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  AgentModel? agentModel;
  List<Property> mlist = [];
  @override
  void initState() {
    APIs.getSpecificAgentDetail(widget.email).listen((event) {
      setState(() {
        agentModel = AgentModel.fromJson(event.data()!);
        APIs.getAssignedPropertyofAgents(agentModel!).then((value) {
          setState(() {
            mlist = value;
          });
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: agentModel != null
                ? Stack(children: [
                    Positioned(
                      top: 30,
                      left: 20,
                      child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        child: Text(
                          "Welcome, ${agentModel!.agent_name}!",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
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
                    Positioned(
                      top: 220,
                      left: 20,
                      child: Container(
                        child: const Text(
                          "Assigned Properties",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    agentModel != null && mlist.length != 0
                        ? Positioned(
                            top: 250,
                            left: 10,
                            right: 10,
                            bottom: 10,
                            child: Container(
                              child: GridView.builder(
                                  itemCount: mlist.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: .8,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: ((context, index) =>
                                      propertyItem(mlist[index]))),
                            ))
                        : Container(
                            height: mq.height * .5,
                            child: Center(
                                child: Lottie.asset(
                              'images/nodata.json',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            )),
                          ),
                    Positioned(
                      top: 80,
                      left: 10,
                      child: Container(
                        height: 80,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(18)),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => GenerateOtpScreen()));
                              },
                              child: const Text(
                                "Generate OTP",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                                height: 24,
                                width: 24,
                                child:
                                    Image(image: AssetImage("images/otp.png")))
                          ],
                        )),
                      ),
                    ),
                  ])
                : const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  )));
  }

  Widget propertyItem(Property property) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AssignedCustomers(property: property, agent: agentModel!)));
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  property.showImg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              property.property_name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              property.address,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${property.cost.toString()} ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ]),
        ),
      ),
    );
  }
}
