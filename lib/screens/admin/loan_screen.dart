import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/customer_model.dart';
import 'package:real_estate/model/property_model.dart';
import 'package:real_estate/screens/common/polyline_map.dart';
import '../../apis/api.dart';
import '../../main.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({
    super.key,
  });
  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  List<CustomerModel> _customerlist = [];
  @override
  Widget build(BuildContext context) {
    _customerlist.clear();
    return SafeArea(
        child: Scaffold(
      persistentFooterButtons: const [
        Center(
            child: Text(
                "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
      ],
      resizeToAvoidBottomInset: false,
      body: Column(children: [
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
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  "Customer who wants loan",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder(
            stream: APIs.getCustomerWhoWantLoan(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return SizedBox();
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.data != null) {
                    if (!_customerlist.contains(snapshot.data!)) {
                      _customerlist.add(snapshot.data!);
                    }
                  }
                  if (_customerlist.isNotEmpty) {
                    return Container(
                      height: mq.height - 250,
                      width: mq.width,
                      child: ListView.builder(
                          itemCount: _customerlist.length,
                          itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 80,
                                    width: mq.width * .8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        _customerlist[index].customer_name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        _customerlist[index].address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      leading: Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(),
                                          child: ClipRRect(
                                            clipBehavior: Clip.hardEdge,
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: Icon(
                                                Icons.circle,
                                                color:
                                                    _customerlist[index].isLoan
                                                        ? Colors.green
                                                        : Colors.red,
                                              ),
                                            ),
                                          )),
                                      trailing: InkWell(
                                        onTap: () {
                                          Dialogs.callNumber(
                                              _customerlist[index].phonenumber);
                                        },
                                        child: Container(
                                            height: 36,
                                            width: 36,
                                            decoration: BoxDecoration(),
                                            child: ClipRRect(
                                              clipBehavior: Clip.hardEdge,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              child: const FittedBox(
                                                fit: BoxFit.fill,
                                                child: Icon(Icons.call),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                    );
                  } else {
                    return const Center(
                      child: Text("No data"),
                    );
                  }
              }
            })
      ]),
    ));
  }
}
