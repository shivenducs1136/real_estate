import 'package:flutter/material.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/property_model.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({super.key});

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Welcome, Alex",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Image(
                      image: AssetImage("images/user2.png"),
                      height: 30,
                      width: 30,
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Assigned Properties",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: propertyWidget(Property(
                    property_name: "My Property Name",
                    bedrooms: "bedrooms",
                    cost: "10000",
                    bathrooms: "bathrooms",
                    garages: "garages",
                    area: "200",
                    id: "id",
                    address: "Extra long property address to test overflow",
                    lat: "lat",
                    lon: "lon",
                    showImg:
                        "https://sitkalaw.ca/wp-content/uploads/2017/08/fb-purchase-property.jpg",
                    yearBuilt: "yearBuilt")),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget propertyWidget(Property p) {
    return Container(
        height: mq.height * .125,
        width: mq.width,
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Image(
                      image: NetworkImage(p.showImg),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${p.property_name}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${p.address}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          "Area : ${p.area} sq. ft.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Cost : ${p.cost}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
