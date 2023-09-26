import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/helper/widgets/nearby_places.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/property_model.dart';
import 'package:real_estate/screens/admin/add_agent.dart';

class AgentDetailsScreen extends StatefulWidget {
  final AgentModel curr_agent;

  const AgentDetailsScreen({super.key, required this.curr_agent});
  @override
  _AgentDetailsScreenState createState() => _AgentDetailsScreenState();
}

class _AgentDetailsScreenState extends State<AgentDetailsScreen> {
  // Define some sample data for the agent
  String name = '';
  String photoUrl = '';
  int age = 35;
  String address = '';
  String dob = "";
  String gender = '';
  List<Property> mlist = [];
  @override
  void initState() {
    name = widget.curr_agent.agent_name;
    photoUrl = widget.curr_agent.photo;
    age = int.parse(widget.curr_agent.age);
    address = widget.curr_agent.address;
    dob = widget.curr_agent.dob;
    gender = widget.curr_agent.isMale ? "Male" : "Female";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddAgentScreen(
                            isUpdate: true, agent: widget.curr_agent)));
              },
              child: Icon(
                Icons.edit_document,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
          title: Text(
            'Agent Details',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Center(
              child: Container(
                height: 100,
                width: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Dialogs.showImage(photoUrl)),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Age: $age',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Address: $address',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'DOB: ${dob}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Gender: $gender',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 16),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Properties Assigned:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            StreamBuilder(
                stream: APIs.getAssignedPropertyofAgents(widget.curr_agent),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final _list = snapshot.data;

                      if (_list != null && _list.isNotEmpty) {
                        return Container(
                            child: NearbyPlaces(
                          email: null,
                          isUpdate: true,
                          nearbyPlaces: _list,
                        ));
                      } else {
                        return const Center(
                          child: Text(
                            "No Property Assigned",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        );
                      }
                  }
                })
          ],
        ),
      ),
    );
  }
}
