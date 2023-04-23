import 'package:flutter/material.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/customer_model.dart';
import 'package:real_estate/screens/admin/agent_details.dart';
import 'package:real_estate/screens/admin/interested_properties.dart';

class AllCustomersScreen extends StatefulWidget {
  const AllCustomersScreen({super.key});

  @override
  State<AllCustomersScreen> createState() => _AllCustomersScreenState();
}

class _AllCustomersScreenState extends State<AllCustomersScreen> {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    "All Customers",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 48,
                  width: 48,
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
                )
              ],
            ),
          ),
          Positioned(
              top: 75,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: Colors.red,
                  ),
                  Text(" - Loan not required"),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.circle,
                    size: 12,
                    color: Colors.green,
                  ),
                  Text(" - Loan required"),
                ],
              )),
          Positioned(
            top: 110,
            left: 10,
            right: 10,
            bottom: 10,
            child: Container(
              child: StreamBuilder(
                  stream: APIs.getAllCustomers(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        List<CustomerModel> _customerList = data
                                ?.map((e) => CustomerModel.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (_customerList.isNotEmpty) {
                          return Container(
                            child: ListView.builder(
                                itemCount: _customerList.length,
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
                                          onTap: () async {
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        InterestedPropertyScreen(
                                                          customerid:
                                                              _customerList[
                                                                      index]
                                                                  .customer_id,
                                                        )));
                                          },
                                          onLongPress: () {},
                                          child: ListTile(
                                            title: Text(
                                                "${_customerList[index].customer_name}"),
                                            subtitle: Text(
                                                "+91 ${_customerList[index].phonenumber}"),
                                            leading: Container(
                                                height: 24,
                                                width: 24,
                                                decoration: BoxDecoration(),
                                                child: ClipRRect(
                                                  clipBehavior: Clip.hardEdge,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: Icon(
                                                      Icons.circle,
                                                      color:
                                                          _customerList[index]
                                                                  .isLoan
                                                              ? Colors.green
                                                              : Colors.red,
                                                    ),
                                                  ),
                                                )),
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
                  }),
            ),
          )
        ]),
      ),
    ));
  }
}
