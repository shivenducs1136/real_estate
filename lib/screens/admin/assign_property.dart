import "package:flutter/material.dart";
import "package:real_estate/apis/api.dart";
import "package:real_estate/helper/agent_searchable.dart";
import "package:real_estate/helper/credentials.dart";
import "package:real_estate/model/agent_model.dart";
import "package:real_estate/model/customer_model.dart";

import "../../helper/dialogs.dart";
import "../../helper/searchable.dart";
import "../../model/property_model.dart";

class AssignPropertyScreen extends StatefulWidget {
  const AssignPropertyScreen({super.key});

  @override
  State<AssignPropertyScreen> createState() => _AssignPropertyScreenState();
}

class _AssignPropertyScreenState extends State<AssignPropertyScreen> {
  List<Property> _list = [];
  List<AgentModel> _agentlist = [];
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _phoneNumber = "";
  String _address = "";
  Property? _selectedProperty;
  AgentModel? _selectedAgent;
  String radioBtnValue = "Purchase";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        persistentFooterButtons: const [
          Center(
              child: Text(
                  "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
        ],
        body: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            // ignore: prefer_const_literals_to_create_immutables
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
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
                  const Text(
                    "  Assign property to agent",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Select Property",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: APIs.getAllProperties(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => Property.fromJson(e.data()))
                                .toList() ??
                            [];

                        return MySearchableDropdown(
                          options: _list,
                          hintText: 'Please Select Property',
                          selectedItem: _selectedProperty == null
                              ? ""
                              : _selectedProperty!.property_name,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedProperty = newValue;
                            });
                          },
                        );
                    }
                  }),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Select Agent",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: APIs.getAllAgents(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _agentlist = data
                                ?.map((e) => AgentModel.fromJson(e.data()))
                                .toList() ??
                            [];

                        return MyAgentSearchableDropdown(
                          options: _agentlist,
                          hintText: 'Please Select Agent',
                          selectedItem: _selectedAgent == null
                              ? ""
                              : _selectedAgent!.agent_name,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedAgent = newValue;
                            });
                          },
                        );
                    }
                  }),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Add customer details",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Phone Number'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _phoneNumber = value!;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Address'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _address = value!;
                        },
                      ),
                      Column(
                        children: [
                          RadioListTile(
                            title: Text("Purchase"),
                            value: "Purchase",
                            groupValue: radioBtnValue,
                            onChanged: (value) {
                              setState(() {
                                radioBtnValue = value.toString();
                              });
                            },
                          ),
                          RadioListTile(
                            title: Text("Renting"),
                            value: "Renting",
                            groupValue: radioBtnValue,
                            onChanged: (value) {
                              setState(() {
                                radioBtnValue = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _selectedProperty != null &&
                                _selectedAgent != null) {
                              _formKey.currentState!.save();
                              APIs.assignPropertyToAgent(
                                      _selectedProperty!, _selectedAgent!)
                                  .then((value) {
                                Dialogs.showProgressBar(context);
                                APIs.isCustomerExists(_phoneNumber)
                                    .then((value) {
                                  if (value != null) {
                                    List<dynamic> prop = value.property_id;
                                    List<dynamic> agent = value.agent_id;
                                    prop.add(_selectedProperty!.id);
                                    agent.add(_selectedAgent!.id);
                                    APIs.addCustomer(CustomerModel(
                                            customer_name: _name,
                                            property_id: prop,
                                            agent_id: agent,
                                            phonenumber: _phoneNumber,
                                            address: _address,
                                            customer_id: _phoneNumber,
                                            isLoan: false,
                                            isPurchase:
                                                radioBtnValue == "Purchase"
                                                    ? true
                                                    : false))
                                        .then((value) async {
                                      await APIs.activityAssignedProperty(
                                          property_id: _selectedProperty!.id,
                                          msg:
                                              "Admin assigned ${_selectedProperty!.property_name} to ${_selectedAgent!.agent_name} with ${_name}",
                                          agent_id: _selectedAgent!.id,
                                          customer_id: _phoneNumber);
                                      // ignore: use_build_context_synchronously
                                      Dialogs.showSnackbar(context,
                                          "Successfully assigned ${_selectedProperty!.property_name} to ${_selectedAgent!.agent_name} with ${_name}");
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    APIs.addCustomer(CustomerModel(
                                            customer_name: _name,
                                            property_id: [
                                              _selectedProperty!.id
                                            ],
                                            agent_id: [_selectedAgent!.id],
                                            phonenumber: _phoneNumber,
                                            address: _address,
                                            customer_id: _phoneNumber,
                                            isLoan: false,
                                            isPurchase:
                                                radioBtnValue == "Purchase"
                                                    ? true
                                                    : false))
                                        .then((value) async {
                                      await APIs.activityAssignedProperty(
                                          property_id: _selectedProperty!.id,
                                          msg:
                                              "Admin assigned ${_selectedProperty!.property_name} to ${_selectedAgent!.agent_name} with ${_name}",
                                          agent_id: _selectedAgent!.id,
                                          customer_id: _phoneNumber);
                                      Dialogs.showSnackbar(context,
                                          "Successfully assigned ${_selectedProperty!.property_name} to ${_selectedAgent!.agent_name} with ${_name}");
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  }
                                });
                              });
                            } else {
                              Dialogs.showSnackbar(
                                  context, "Property or Agent can't be empty");
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
    ;
  }
}
