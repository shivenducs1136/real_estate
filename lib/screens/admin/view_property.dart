import 'dart:developer';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/model/image_model.dart';
import 'package:real_estate/screens/admin/add_property.dart';
import 'package:real_estate/helper/media.dart';

import '../../main.dart';
import '../../model/property_model.dart';

class ViewPropertyScreen extends StatefulWidget {
  const ViewPropertyScreen({super.key});

  @override
  State<ViewPropertyScreen> createState() => _ViewPropertyScreenState();
}

class _ViewPropertyScreenState extends State<ViewPropertyScreen> {
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
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () {
            if (_isSearching) {
              setState(() {
                _isSearching = !_isSearching;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
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
                              "  All Properties",
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
                    child: StreamBuilder(
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
                              if (_list.isNotEmpty) {
                                return Container(
                                  child: GridView.builder(
                                      itemCount: _isSearching
                                          ? _searchList.length
                                          : _list.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: .8,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemBuilder: ((context, index) =>
                                          propertyItem(_isSearching
                                              ? _searchList[index]
                                              : _list[index]))),
                                );
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
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget propertyItem(Property property) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AddPropertyScreen(currProp: property, isUpdate: true)));
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
              style: TextStyle(
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
