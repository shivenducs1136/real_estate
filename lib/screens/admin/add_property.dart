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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.black,
                  ),
                  Text(
                    "  Add Property",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  )
                ]),
                SizedBox(
                  height: mq.height * .05,
                ),
                Text(
                  "Property Name",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: mq.height * .01,
                ),
                TextFormField(
                  initialValue: null,
                  onSaved: (val) => {},
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : "Required Field",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'eg. feeling happy!',
                    label: Text("About"),
                  ),
                ),
                SizedBox(
                  height: mq.height * .01,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Bedrooms"),
                        TextFormField(
                          initialValue: null,
                          onSaved: (val) => {},
                          validator: (val) => val != null && val.isNotEmpty
                              ? null
                              : "Required Field",
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            hintText: 'eg. 1,2,3',
                            label: Text("Bedrooms"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: mq.height * .05,
                ),
                Container(
                  height: mq.height * .06,
                  child: Center(
                      child: Text(
                    "Add Property",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 44, 7, 253),
                      borderRadius: BorderRadius.circular(20)),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
