import 'dart:developer';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/widgets/interested_cust.dart';
import 'package:real_estate/helper/widgets/nearby_places.dart';
import 'package:real_estate/helper/widgets/recommended_places.dart';
import 'package:real_estate/model/image_model.dart';
import 'package:real_estate/screens/admin/add_property.dart';
import 'package:real_estate/helper/media.dart';

import '../../helper/credentials.dart';
import '../../main.dart';
import '../../model/property_model.dart';

class CustomerProperty extends StatefulWidget {
  const CustomerProperty({super.key, required this.customerid});
  final String customerid;

  @override
  State<CustomerProperty> createState() => _CustomerPropertyState();
}

class _CustomerPropertyState extends State<CustomerProperty> {
  List<Property> _list = [];
  List<ImageModel> _imglist = [];
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  final List<Property> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _list.clear();
    return SafeArea(
      child: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () {
            if (_isSearching) {
              setState(() {
                _searchText = "";
                _isSearching = !_isSearching;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            persistentFooterButtons: const [
              Center(
                  child: Text(
                      "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
            ],
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                height: mq.height,
                width: mq.width,
                child: Stack(children: [
                  Row(
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
                      (_isSearching)
                          ? const Text(
                              "  Search Properties",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              "Associated Properties",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                  Positioned(
                    top: 45,
                    left: 10,
                    right: 10,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        _isSearching = true;
                        _searchList.clear();
                        for (var i in _list) {
                          {
                            if (i.property_name
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              _searchList.add(i);
                              setState(() {
                                _searchList;
                              });
                            }
                          }
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Positioned(
                    top: 130,
                    left: 10,
                    right: 10,
                    bottom: 10,
                    child: SingleChildScrollView(
                      child: StreamBuilder(
                          stream: APIs.getAssignedProperty(widget.customerid),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return const SizedBox();
                              case ConnectionState.active:
                              case ConnectionState.done:
                                if (snapshot.hasData) {
                                  if (!_list.contains(snapshot.data)) {
                                    _list.add(snapshot.data!);
                                  }
                                }
                                if (_list.isNotEmpty) {
                                  return _isSearching
                                      ? Container(
                                          child: InterestedPlaces(
                                          email: null,
                                          isUpdate: true,
                                          nearbyPlaces: _searchList,
                                        ))
                                      : Container(
                                          child: NearbyPlaces(
                                          email: null,
                                          isUpdate: true,
                                          nearbyPlaces: _list,
                                        ));
                                } else {
                                  return const Center(
                                    child: Text(
                                      "No Property Added",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  );
                                }
                            }
                          }),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
