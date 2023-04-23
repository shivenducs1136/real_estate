import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/screens/admin/agent_details.dart';
import 'package:real_estate/screens/admin/assigned_properties.dart';
import 'package:real_estate/screens/admin/choose_property.dart';

import '../../helper/dialogs.dart';
import '../../main.dart';

class ChooseAgentScreen extends StatefulWidget {
  const ChooseAgentScreen({super.key});

  @override
  State<ChooseAgentScreen> createState() => _ChooseAgentScreenState();
}

class _ChooseAgentScreenState extends State<ChooseAgentScreen> {
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
                    "Choose Agent",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 80,
            left: 10,
            right: 10,
            bottom: 10,
            child: Container(
              child: StreamBuilder(
                  stream: APIs.getAllAgents(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        List<AgentModel> _agentlist = data
                                ?.map((e) => AgentModel.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (_agentlist.isNotEmpty) {
                          return Container(
                            child: ListView.builder(
                                itemCount: _agentlist.length,
                                itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, bottom: 10),
                                      child: Container(
                                        height: 80,
                                        width: mq.width * .8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 1, color: Colors.black),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ChooseProperties(
                                                          curr_agent:
                                                              _agentlist[index],
                                                        )));
                                          },
                                          onLongPress: () {
                                            Dialogs.showInputDialog(
                                                context: context,
                                                title: "Delete",
                                                hint:
                                                    "Are you sure want to delete agent ${_agentlist[index].agent_name}?",
                                                onOk: () {
                                                  Dialogs.showProgressBar(
                                                      context);
                                                  APIs.deleteAgentWithAgentId(
                                                          _agentlist[index].id)
                                                      .then((value) {
                                                    Navigator.pop(context);
                                                    Dialogs.showSnackbar(
                                                        context,
                                                        "Deleted Successfully");
                                                    _agentlist.remove(index);
                                                  });
                                                },
                                                onCancel: () {});
                                          },
                                          child: ListTile(
                                            title: Text(
                                                "${_agentlist[index].agent_name}"),
                                            subtitle: Text(
                                                "${_agentlist[index].email}"),
                                            leading: Container(
                                                height: 48,
                                                width: 48,
                                                decoration: BoxDecoration(),
                                                child: ClipRRect(
                                                  clipBehavior: Clip.hardEdge,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: FadeInImage(
                                                        placeholder: AssetImage(
                                                            "images/picture.png"),
                                                        image: NetworkImage(
                                                            _agentlist[index]
                                                                .photo),
                                                        imageErrorBuilder:
                                                            (context, error,
                                                                stackTrace) {
                                                          return Image.asset(
                                                              'images/picture.png',
                                                              fit: BoxFit
                                                                  .fitWidth);
                                                        },
                                                      )),
                                                )),
                                          ),
                                        ),
                                      ),
                                    )),
                          );
                        } else {
                          return Center(
                            child: Text("No data"),
                          );
                        }
                    }
                  }),
            ),
          )
        ]),
      ),
    ));
  }
}
