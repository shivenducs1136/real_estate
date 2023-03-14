import "package:flutter/material.dart";

import "../../main.dart";

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              // ignore: prefer_const_literals_to_create_immutables
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          "   Add Property",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .04,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Property Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: mq.height * .01,
                        ),
                        SizedBox(
                          height: mq.height * .05,
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: "eg. XYZ Villa",
                              labelText: "Property Name",
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bedrooms",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: mq.height * .01,
                            ),
                            SizedBox(
                              height: mq.height * .05,
                              width: mq.width * .3,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 1,2,3",
                                  labelText: "Bedrooms",
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: mq.width * .1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bedrooms",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: mq.height * .01,
                            ),
                            SizedBox(
                              height: mq.height * .05,
                              width: mq.width * .3,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 1,2,3",
                                  labelText: "Bedrooms",
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Garages",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: mq.height * .01,
                            ),
                            SizedBox(
                              height: mq.height * .05,
                              width: mq.width * .3,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 1,2,3",
                                  labelText: "Garages",
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: mq.width * .1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Area",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: mq.height * .01,
                            ),
                            SizedBox(
                              height: mq.height * .05,
                              width: mq.width * .3,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 32 sq.ft.",
                                  labelText: "Area in sq. ft.",
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: mq.height * .01,
                            ),
                            SizedBox(
                              height: mq.height * .05,
                              width: mq.width * .3,
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 1,2,3",
                                  labelText: "Status",
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: mq.width * .1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Year built",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: mq.height * .01,
                            ),
                            SizedBox(
                              height: mq.height * .05,
                              width: mq.width * .3,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 2012",
                                  labelText: "Year Build",
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .01,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .01,
                    ),
                    SizedBox(
                      height: mq.height * .15,
                      width: mq.width * 1,
                      child: TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: "eg. XYZ street",
                        ),
                        maxLines: 4,
                      ),
                    ),
                    SizedBox(
                      width: mq.width * .1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Add Images",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              width: mq.width * .1,
                            ),
                            Image.asset(
                              "images/addimg.png",
                              height: 50,
                              width: 50,
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("GPS Location"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .1,
                    ),
                    Container(
                      height: mq.height * .07,
                      width: mq.width,
                      child: Center(
                        child: Text(
                          "Add Property",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
