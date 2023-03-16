import "dart:developer";

import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:image_picker/image_picker.dart";
import "package:real_estate/apis/api.dart";
import "package:real_estate/model/property_model.dart";
import "../../helper/dialogs.dart";
import "../../main.dart";

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final formKey = GlobalKey<FormState>();
  String property_name = "";
  String bedrooms = "";
  String bathrooms = "";
  String garages = "";
  String area = "";
  String cost = "";
  String year_built = "";
  String address = "";
  String lat = "";
  String long = "";
  List<XFile>? images = <XFile>[];
  bool isImageAdded = false;
  bool isLocationFetched = false;
  String? _currentAddress;
  Position? _currentPosition;
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
                            onChanged: (value) {
                              setState(() {
                                property_name = value;
                              });
                            },
                            keyboardType: TextInputType.name,
                            validator: (val) => val != null && val.isNotEmpty
                                ? null
                                : "Required Field",
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
                                onChanged: (value) {
                                  setState(() {
                                    bedrooms = value!;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val != null && val.isNotEmpty
                                        ? null
                                        : "Required Field",
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
                              "Bathrooms",
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
                                onChanged: (value) {
                                  setState(() {
                                    bathrooms = value!;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val != null && val.isNotEmpty
                                        ? null
                                        : "Required Field",
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 1,2,3",
                                  labelText: "Bathrooms",
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
                                onChanged: (value) {
                                  setState(() {
                                    garages = value!;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val != null && val.isNotEmpty
                                        ? null
                                        : "Required Field",
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
                                onChanged: (value) {
                                  setState(() {
                                    area = value!;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val != null && val.isNotEmpty
                                        ? null
                                        : "Required Field",
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
                              "Cost",
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
                                onChanged: (value) {
                                  setState(() {
                                    cost = value!;
                                  });
                                },
                                keyboardType: TextInputType.name,
                                validator: (val) =>
                                    val != null && val.isNotEmpty
                                        ? null
                                        : "Required Field",
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  hintText: "eg. 1,2,3",
                                  labelText: "Cost",
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
                                onChanged: (value) {
                                  setState(() {
                                    year_built = value!;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val != null && val.isNotEmpty
                                        ? null
                                        : "Required Field",
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
                        onChanged: (value) {
                          setState(() {
                            address = value!;
                          });
                        },
                        keyboardType: TextInputType.streetAddress,
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : "Required Field",
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
                            InkWell(
                              onTap: () async {
                                // addimages
                                final ImagePicker _picker = ImagePicker();
                                List<XFile>? img = await _picker
                                    .pickMultiImage()
                                    .then((value) {
                                  setState(() {
                                    images = value;
                                    isImageAdded = true;
                                  });
                                });
                              },
                              child: Image.asset(
                                "images/addimg.png",
                                height: 50,
                                width: 50,
                              ),
                            ),
                            if (isImageAdded)
                              Text(
                                "${images?.length} images selected",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _handleLocationPermission().then(
                              (value) {
                                _getCurrentPosition().then((value) {
                                  setState(() {
                                    lat =
                                        _currentPosition?.latitude.toString() ??
                                            "";
                                    long = _currentPosition?.longitude
                                            .toString() ??
                                        "";
                                    isLocationFetched = true;
                                  });
                                });
                              },
                            );
                          },
                          child: Text("GPS Location"),
                        ),
                        if (isLocationFetched)
                          Icon(Icons.done_all_outlined, color: Colors.green)
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .1,
                    ),
                    InkWell(
                      onTap: () {
                        // add data to firebase
                        Property p = Property(
                            property_name: property_name,
                            bedrooms: bedrooms,
                            bathrooms: bathrooms,
                            garages: garages,
                            cost: cost,
                            area: area,
                            id: "${DateTime.now().microsecondsSinceEpoch}",
                            address: address,
                            lat: lat,
                            lon: long,
                            showImg: 'https://picsum.photos/200/300');
                        Dialogs.showProgressBar(context);
                        APIs.addPropertyToFirebase(p).then((value) {
                          APIs.addPropertyPhotos(images!, p).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Dialogs.showSnackbar(
                                context, "Property Added Successfully");
                          });
                        });
                      },
                      child: Container(
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
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = """${place.street}, ${place.subLocality},
          ${place.subAdministrativeArea}, ${place.postalCode}""";
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
