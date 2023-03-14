import "package:flutter/material.dart";

class AssignPropertyScreen extends StatefulWidget {
  const AssignPropertyScreen({super.key});

  @override
  State<AssignPropertyScreen> createState() => _AssignPropertyScreenState();
}

class _AssignPropertyScreenState extends State<AssignPropertyScreen> {
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
                    "  Assign property to agent",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
    ;
  }
}
