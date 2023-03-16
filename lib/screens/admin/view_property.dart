import 'dart:developer';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/model/image_model.dart';

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
      child: Scaffold(
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
                    "  All Properties",
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
              TextField(
                controller: _searchController,
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
              const SizedBox(
                height: 50,
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
                        if (_list.isNotEmpty) {
                          return Container(
                              height: mq.height,
                              child: GridView.builder(
                                  itemCount: _list.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio:
                                        (mq.height / mq.width) * .33,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: ((context, index) =>
                                      propertyItem(_list[index]))));
                        } else {
                          return const Center(
                            child: Text(
                              "No Property Added",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          );
                        }
                    }
                  })
            ]),
          ),
        ),
      ),
    );
  }

  Widget propertyItem(Property p) {
    return Container(
      width: mq.width * .4,
      height: mq.height * .27,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.0)),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: mq.height * .17,
            width: mq.width * .4,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: FittedBox(fit: BoxFit.fill, child: Image.network(p.showImg)),
          ),
          SizedBox(
            height: mq.height * .007,
          ),
          Text(
            p.property_name,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            textWidthBasis: TextWidthBasis.parent,
          ),
          Text(
            "${p.area} sq. ft.",
            style: TextStyle(color: Colors.black, fontSize: 12),
            maxLines: 1,
            textWidthBasis: TextWidthBasis.parent,
          ),
          SizedBox(
            height: mq.height * .01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "₹ ${p.cost}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
                textWidthBasis: TextWidthBasis.parent,
              ),
              Icon(
                Icons.edit,
                size: 22,
              )
            ],
          )
        ]),
      ),
    );
  }
}
