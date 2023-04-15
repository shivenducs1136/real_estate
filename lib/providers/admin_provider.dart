import 'package:flutter/foundation.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:real_estate/model/property_model.dart';

class AdminProvider with ChangeNotifier {
  String _property_name = "";
  String _bedrooms = "";
  String _bathrooms = "";
  String _garages = "";
  String _area = "";
  String _cost = "";
  String _year_built = "";
  String _address = "";
  String _lat = "";
  String _long = "";
  List<XFile>? images = <XFile>[];
  bool isImageAdded = false;
  bool isLocationFetched = false;
  String _currentAddress = "";
  Position? _currentPosition;
  PickResult? _selectedPlace;
  String _id = "";
  String _showImg = "";
  String _yearBuilt = "";

  Property get getProperty {
    return Property(
        property_name: _property_name,
        bedrooms: _bedrooms,
        cost: _cost,
        bathrooms: _bathrooms,
        garages: _garages,
        area: _area,
        id: _id,
        address: _address,
        lat: _lat,
        lon: _long,
        showImg: _showImg,
        yearBuilt: _yearBuilt);
  }

  void setProperty(Property p) {
    _property_name = p.property_name;
    _bedrooms = p.bedrooms;
    _bathrooms = p.bathrooms;
    _garages = p.garages;
    _area = p.area;
    _cost = p.cost;
    _year_built = p.yearBuilt;
    _address = p.address;
    _lat = p.lat;
    _long = p.lon;
    _id = p.id;
    _showImg = p.showImg;
    _yearBuilt = p.yearBuilt;
  }

  void setShowImage(String imageUri) {
    _showImg = imageUri;
  }

  void setCurrentAddress(String currAdress) {
    _currentAddress = currAdress;
  }

  void setPosition(Position position) {
    _currentPosition = position;
  }

  Position? get getPosition => _currentPosition;
  String get getCurrentAddress => _currentAddress;
}
