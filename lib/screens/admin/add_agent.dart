import "dart:math";

import "package:calendar_date_picker2/calendar_date_picker2.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:real_estate/apis/api.dart";
import "package:real_estate/helper/my_date_util.dart";
import "package:real_estate/model/agent_model.dart";
import "package:real_estate/model/mailer.dart";

import "../../helper/dialogs.dart";
import "../../main.dart";

class AddAgentScreen extends StatefulWidget {
  const AddAgentScreen(
      {super.key, required this.isUpdate, required this.agent});
  final bool isUpdate;
  final AgentModel? agent;
  @override
  State<AddAgentScreen> createState() => _AddAgentScreenState();
}

class _AddAgentScreenState extends State<AddAgentScreen> {
  final formKey = GlobalKey<FormState>();
  String agent_name = "";
  String agent_email = "";
  String age = "";
  String phone_number = "";
  String address = "";
  String photourl = "";
  List<DateTime?> dob = [];
  XFile? img;
  bool isImageAdded = false;
  bool isMale = false;
  @override
  Widget build(BuildContext context) {
    if (widget.agent != null) {
      agent_name = widget.agent!.agent_name;
      agent_email = widget.agent!.email;
      age = widget.agent!.age;
      phone_number = widget.agent!.phone_number;
      address = widget.agent!.address;
      photourl = widget.agent!.photo;
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
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
                        Text(
                          widget.isUpdate ? "   Update Agent" : "   Add Agent",
                          style: const TextStyle(
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
                        const Text(
                          "Agent Name",
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
                            onChanged: (value) {
                              setState(() {
                                agent_name = value;
                              });
                            },
                            validator: (val) => val != null && val.isNotEmpty
                                ? null
                                : "Required Field",
                            keyboardType: TextInputType.name,
                            initialValue:
                                widget.isUpdate ? widget.agent?.agent_name : '',
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: "eg. John Slicky",
                              labelText: "Agent Name",
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .01,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email Id",
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
                            initialValue:
                                widget.isUpdate ? widget.agent?.email : '',
                            onChanged: (value) {
                              setState(() {
                                agent_email = value;
                              });
                            },
                            validator: (val) => val != null && val.isNotEmpty
                                ? null
                                : "Required Field",
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: "eg. john@gmail.com",
                              labelText: "john@gmail.com",
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "DOB : ${dob.isNotEmpty ? MyDateUtil.getEventDetailDate(dob[0]!) : ""}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                var results =
                                    await showCalendarDatePicker2Dialog(
                                  context: context,
                                  config:
                                      CalendarDatePicker2WithActionButtonsConfig(),
                                  dialogSize: const Size(325, 400),
                                  value: dob,
                                  borderRadius: BorderRadius.circular(15),
                                );
                                setState(() {
                                  dob = results!;
                                });
                              },
                              child: Icon(
                                Icons.calendar_today,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Male ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Switch(
                                value: !isMale,
                                onChanged: (context) {
                                  isMale = !isMale;
                                  setState(() {});
                                }),
                            Text(
                              " Female",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                            const Text(
                              "Age",
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
                                initialValue:
                                    widget.isUpdate ? widget.agent?.age : '',
                                onChanged: (value) {
                                  setState(() {
                                    age = value;
                                  });
                                },
                                validator: (val) =>
                                    val != null && val.isNotEmpty
                                        ? null
                                        : "Required Field",
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 21,22,23",
                                  labelText: "Age",
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: mq.width * .05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Phone Number",
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
                              width: mq.width * .5,
                              child: TextFormField(
                                initialValue: widget.isUpdate
                                    ? widget.agent?.phone_number
                                    : '',
                                onChanged: (value) {
                                  setState(() {
                                    phone_number = value;
                                  });
                                },
                                validator: (val) =>
                                    val != null && val.isNotEmpty
                                        ? null
                                        : "Required Field",
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 9988776655",
                                  labelText: "Phone Number",
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
                    SizedBox(
                      height: mq.height * .01,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
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
                        initialValue:
                            widget.isUpdate ? widget.agent?.address : '',
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : "Required Field",
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Add Agent Image",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              width: mq.width * .1,
                            ),
                            InkWell(
                              onTap: () async {
                                final ImagePicker _picker = ImagePicker();
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  img = image;
                                });
                              },
                              child: Image.asset(
                                "images/addimg.png",
                                height: 50,
                                width: 50,
                              ),
                            ),
                            if (isImageAdded)
                              const Text(
                                "Agent image added",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .1,
                    ),
                    InkWell(
                      onTap: () {
                        if (widget.isUpdate) {
                          var value = new Random();
                          var codeNumber =
                              (value.nextInt(900000) + 100000).toString();
                          Dialogs.showProgressBar(context);
                          AgentModel a = AgentModel(
                            password: codeNumber,
                            agent_name: agent_name,
                            email: agent_email,
                            age: age,
                            phone_number: phone_number,
                            address: address,
                            id: "${agent_email}",
                            photo: photourl != ""
                                ? photourl
                                : 'https://www.bing.com/images/blob?bcid=r3B777OKZl0FlejhWxYdTD-8qF4A.....x4',
                            dob: dob.isNotEmpty
                                ? MyDateUtil.getEventDetailDate(dob[0]!)
                                : "",
                            isMale: isMale,
                          );
                          APIs.addAgentToFirebase(a).then((value) {
                            if (img != null) {
                              APIs.addAgentImage(img!, a).then((value) {
                                widget.isUpdate
                                    ? APIs.activityAddAgent(
                                        msg: "${agent_name} updated by Admin",
                                        agent_id: agent_email)
                                    : APIs.activityUpdateAgent(
                                        msg: "${agent_name} added by Admin",
                                        agent_id: agent_email);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Mailer.sendCredentialsEmail(
                                    password: codeNumber,
                                    destEmail: agent_email);
                                Dialogs.showSnackbar(context,
                                    "Agent ${widget.isUpdate ? "Updated" : "Added"} Successfully");
                              });
                            } else {
                              widget.isUpdate
                                  ? APIs.activityAddAgent(
                                      msg: "${agent_name} updated by Admin",
                                      agent_id: agent_email)
                                  : APIs.activityUpdateAgent(
                                      msg: "${agent_name} added by Admin",
                                      agent_id: agent_email);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Dialogs.showSnackbar(context,
                                  "Agent ${widget.isUpdate ? "Updated" : "Added"} Successfully");
                            }
                          });
                        } else {
                          if (agent_email.isNotEmpty) {
                            APIs.isAgentExists(agent_email).then((value) {
                              if (value == true) {
                                var value = new Random();
                                var codeNumber =
                                    (value.nextInt(900000) + 100000).toString();
                                Dialogs.showProgressBar(context);
                                AgentModel a = AgentModel(
                                    password: codeNumber,
                                    agent_name: agent_name,
                                    email: agent_email,
                                    age: age,
                                    phone_number: phone_number,
                                    address: address,
                                    id: "${agent_email}",
                                    photo:
                                        'https://www.bing.com/images/blob?bcid=r3B777OKZl0FlejhWxYdTD-8qF4A.....x4',
                                    dob: dob.isNotEmpty
                                        ? MyDateUtil.getEventDetailDate(dob[0]!)
                                        : "",
                                    isMale: isMale);
                                APIs.addAgentToFirebase(a).then((value) {
                                  if (img != null) {
                                    APIs.addAgentImage(img!, a).then((value) {
                                      widget.isUpdate
                                          ? APIs.activityAddAgent(
                                              msg:
                                                  "${agent_name} updated by Admin",
                                              agent_id: agent_email)
                                          : APIs.activityUpdateAgent(
                                              msg:
                                                  "${agent_name} added by Admin",
                                              agent_id: agent_email);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Mailer.sendCredentialsEmail(
                                          password: codeNumber,
                                          destEmail: agent_email);
                                      Dialogs.showSnackbar(context,
                                          "Agent ${widget.isUpdate ? "Updated" : "Added"} Successfully");
                                    });
                                  } else {
                                    widget.isUpdate
                                        ? APIs.activityAddAgent(
                                            msg:
                                                "${agent_name} updated by Admin",
                                            agent_id: agent_email)
                                        : APIs.activityUpdateAgent(
                                            msg: "${agent_name} added by Admin",
                                            agent_id: agent_email);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Dialogs.showSnackbar(context,
                                        "Agent ${widget.isUpdate ? "Updated" : "Added"} Successfully");
                                  }
                                });
                              } else {
                                Dialogs.showSnackbar(
                                    context, "Agent already exists");
                              }
                            });
                          }
                        }
                      },
                      child: Container(
                        height: mq.height * .07,
                        width: mq.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue),
                        child: Center(
                          child: Text(
                            widget.isUpdate ? "Update Agent" : "Add Agent",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
