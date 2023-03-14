class Property {
  Property({
    required this.property_name,
    required this.bedrooms,
    required this.bathrooms,
    required this.garages,
    required this.area,
    required this.id,
    required this.address,
    required this.lat,
    required this.lon,
  });
  late String property_name;
  late String bedrooms;
  late String bathrooms;
  late String garages;
  late String area;
  late String id;
  late String address;
  late String lat;
  late String lon;

  Property.fromJson(Map<String, dynamic> json) {
    property_name = json['property_name'] ?? '';
    bedrooms = json['bedrooms'] ?? '';
    bathrooms = json['bathrooms'] ?? '';
    garages = json['garages'] ?? '';
    area = json['area'] ?? '';
    id = json['id'] ?? '';
    address = json['address'] ?? '';
    lat = json['lat'] ?? '';
    lon = json['lon'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['property_name'] = property_name;
    _data['bedrooms'] = bedrooms;
    _data['bathrooms'] = bathrooms;
    _data['garages'] = garages;
    _data['area'] = area;
    _data['id'] = id;
    _data['address'] = address;
    _data['lat'] = lat;
    _data['lon'] = lon;
    return _data;
  }
}
