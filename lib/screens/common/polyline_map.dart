import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/credentials.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/model/customer_model.dart';

class PolyMapScreen extends StatefulWidget {
  const PolyMapScreen(
      {super.key,
      required this.customerModel,
      required this.agentId,
      required this.propId});
  final CustomerModel customerModel;
  final String agentId;
  final String propId;
  @override
  State<PolyMapScreen> createState() => Poly_MapScreenState();
}

class Poly_MapScreenState extends State<PolyMapScreen> {
  final Set<Polyline> polyline = {};
  List<Marker> _marker = [];
  GoogleMapController? _controller;
  List<LatLng>? routeCoords;
  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyC00TWC-5aB9X7t_S3_bfckbW6kJKzcYMA");

  @override
  void initState() {
    _marker.add(Marker(
        markerId: MarkerId('1'), position: LatLng(28.7515285, 77.4995344)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        persistentFooterButtons: const [
          Center(
              child: Text(
                  "${Credentials.COMPANY_NAME} - ${Credentials.COMPANY_EMAIL}"))
        ],
        resizeToAvoidBottomInset: false,
        body: Container(
          child: !(routeCoords == null || routeCoords!.isEmpty)
              ? GoogleMap(
                  onMapCreated: onMapCreated,
                  polylines: polyline,
                  markers: Set<Marker>.of(_marker),
                  initialCameraPosition:
                      CameraPosition(target: routeCoords![0], zoom: 14.0),
                  mapType: MapType.normal,
                )
              : Container(
                  child: const Center(
                  child: Text("No Agent Tracking Record"),
                )),
        ));
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    await APIs.getAgentCoordinates(
            widget.customerModel, widget.propId, widget.agentId)
        .then((value) {
      log(value.toString());
      setState(() {
        _controller = controller;
        Dialogs.showProgressBar(context);
        Navigator.pop(context);
        routeCoords = value;
        polyline.add(Polyline(
            polylineId: PolylineId('route1'),
            visible: true,
            points: value,
            width: 4,
            color: Colors.blue,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap));
      });
    });
  }
}
