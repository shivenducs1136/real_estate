import "dart:developer";
import "dart:io";
import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_place_picker_mb/google_maps_place_picker.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";
import "package:real_estate/apis/api.dart";
import "package:real_estate/model/property_model.dart";
import "package:real_estate/providers/admin_provider.dart";
import "package:real_estate/screens/admin/map_screen.dart";
import "package:real_estate/screens/admin/view_property.dart";
import "../../helper/dialogs.dart";
import "../../main.dart";
import 'package:map_location_picker/map_location_picker.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

class AddPropertyScreen extends StatefulWidget {
  AddPropertyScreen(
      {super.key, required this.currProp, required this.isUpdate});
  final Property? currProp;
  final bool isUpdate;
  static final kInitialPosition = LatLng(28.644800, 77.216721);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
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
  String _currentAddress = "";
  Position? _currentPosition;
  PickResult? selectedPlace;
  bool _showPlacePickerInContainer = false;
  bool _showGoogleMapInContainer = false;
  List<String> areaOptions = ["Flat (in sq ft)", "Land (in sq mt)"];
  bool isFlat = false;
  bool _mapsInitialized = false;
  String _mapsRenderer = "latest";
  void initRenderer() {
    if (_mapsInitialized) return;
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      switch (_mapsRenderer) {
        case "legacy":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.legacy);
          break;
        case "latest":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.latest);
          break;
      }
    }
    setState(() {
      _mapsInitialized = true;
    });
  }

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
                        Text(
                          widget.isUpdate
                              ? "   Update Property"
                              : "   Add Property",
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
                            initialValue: !widget.isUpdate
                                ? ""
                                : widget.currProp!.property_name,
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
                            const Text(
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
                                initialValue: !widget.isUpdate
                                    ? ""
                                    : widget.currProp!.bedrooms,
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
                            const Text(
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
                                initialValue: !widget.isUpdate
                                    ? ""
                                    : widget.currProp!.bathrooms,
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
                            const Text(
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
                              width: 90,
                              child: TextFormField(
                                initialValue: !widget.isUpdate
                                    ? ""
                                    : widget.currProp!.garages,
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
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
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
                              width: 90,
                              child: TextFormField(
                                initialValue: !widget.isUpdate
                                    ? ""
                                    : widget.currProp!.area,
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
                                  labelText: "Area..",
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Row(
                            children: [
                              const Text(
                                "   Flat \n(in sq ft)",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 8),
                              ),
                              Switch(
                                  value: widget.isUpdate
                                      ? widget.currProp!.area.contains("ft")
                                          ? false
                                          : true
                                      : isFlat,
                                  onChanged: (context) {
                                    isFlat = !isFlat;
                                    setState(() {});
                                  }),
                              const Text(
                                "   Land \n(in sq mt)",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 8),
                              ),
                            ],
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
                            const Text(
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
                                initialValue: !widget.isUpdate
                                    ? ""
                                    : widget.currProp!.cost,
                                onChanged: (value) {
                                  setState(() {
                                    cost = value!;
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
                            const Text(
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
                                initialValue: !widget.isUpdate
                                    ? ""
                                    : widget.currProp!.yearBuilt,
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
                            !widget.isUpdate ? "" : widget.currProp!.address,
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
                            const Text(
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
                                XFile? img = await _picker
                                    .pickImage(source: ImageSource.gallery)
                                    .then((value) {
                                  setState(() {
                                    images!.add(value!);
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
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            _handleLocationPermission().then(
                              (value) async {
                                await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.best)
                                    .then((initialpos) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return PlacePicker(
                                          resizeToAvoidBottomInset:
                                              false, // only works in page mode, less flickery
                                          apiKey: Platform.isAndroid
                                              ? "AIzaSyC00TWC-5aB9X7t_S3_bfckbW6kJKzcYMA"
                                              : "AIzaSyC00TWC-5aB9X7t_S3_bfckbW6kJKzcYMA",
                                          hintText: "Find a place ...",
                                          searchingText: "Please wait ...",
                                          selectText: "Select place",
                                          outsideOfPickAreaText:
                                              "Place not in area",
                                          initialPosition: LatLng(
                                              initialpos.latitude,
                                              initialpos.longitude),
                                          useCurrentLocation: true,
                                          selectInitialPosition: true,
                                          usePinPointingSearch: true,
                                          usePlaceDetailSearch: true,
                                          zoomGesturesEnabled: true,
                                          zoomControlsEnabled: true,
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            print("Map created");
                                          },
                                          onPlacePicked: (PickResult result) {
                                            print(
                                                "Place picked: ${result.formattedAddress}");
                                            setState(() {
                                              selectedPlace = result;
                                              Navigator.pop(context);
                                              lat = result
                                                  .geometry!.location.lat
                                                  .toString();
                                              long = result
                                                  .geometry!.location.lng
                                                  .toString();
                                              _currentAddress =
                                                  result.formattedAddress ?? "";
                                            });
                                          },
                                          onMapTypeChanged: (MapType mapType) {
                                            print(
                                                "Map type changed to ${mapType.toString()}");
                                          },
                                        );
                                      },
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          child: Text("Locate Property"),
                        ),
                        if (isLocationFetched)
                          Icon(Icons.done_all_outlined, color: Colors.green)
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .01,
                    ),
                    Center(
                      child: Container(
                        width: mq.width * .7,
                        child: Text(
                          "${_currentAddress}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * .05,
                    ),
                    InkWell(
                      onTap: () {
                        // add data to firebase
                        String dateTime =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        Property p = Property(
                            property_name: property_name,
                            bedrooms: bedrooms,
                            bathrooms: bathrooms,
                            garages: garages,
                            cost: cost,
                            area: isFlat ? area + " sq ft" : area + " sq mt",
                            id: "${dateTime}",
                            address: address,
                            lat: lat,
                            lon: long,
                            showImg: 'https://picsum.photos/200/300',
                            yearBuilt: year_built);
                        Dialogs.showProgressBar(context);
                        if (images == null || images!.isEmpty) {
                          Navigator.pop(context);
                          Dialogs.showSnackbar(
                              context, "Please add atleast 1 image");
                        } else if (property_name == "" ||
                            cost == "" ||
                            lat == "" ||
                            long == "" ||
                            year_built == "") {
                          Navigator.pop(context);
                          Dialogs.showSnackbar(
                              context, "Please add all details");
                        } else {
                          if (!widget.isUpdate) {
                            APIs.addPropertyToFirebase(p).then((value) {
                              APIs.activityAddProperty(
                                      property_id: dateTime,
                                      msg:
                                          "Property - ${property_name} added by Admin")
                                  .then((value) {
                                APIs.addPropertyPhotos(images!, p)
                                    .then((value) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ViewPropertyScreen()));
                                  Dialogs.showSnackbar(
                                      context, "Property Added Successfully");
                                });
                              });
                            });
                          } else {
                            APIs.addPropertyToFirebase(p).then((value) {
                              APIs.activityUpdateProperty(
                                      property_id: dateTime,
                                      msg:
                                          "Property - ${property_name} updated by Admin")
                                  .then((value) {
                                APIs.addPropertyPhotos(images!, p)
                                    .then((value) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ViewPropertyScreen()));
                                  Dialogs.showSnackbar(
                                      context, "Property Updated Successfully");
                                });
                              });
                            });
                          }
                        }
                      },
                      child: Container(
                        height: mq.height * .07,
                        width: mq.width,
                        child: Center(
                          child: Text(
                            widget.isUpdate
                                ? "Update Property"
                                : "Add Property",
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
