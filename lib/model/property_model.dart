class Property {
  Property(
      {required this.property_name,
      required this.bedrooms,
      required this.cost,
      required this.bathrooms,
      required this.garages,
      required this.area,
      required this.id,
      required this.address,
      required this.lat,
      required this.lon,
      required this.showImg,
      required this.yearBuilt});
  late String property_name;
  late String bedrooms;
  late String bathrooms;
  late String garages;
  late String area;
  late String id;
  late String address;
  late String lat;
  late String lon;
  late String cost;
  late String showImg;
  late String yearBuilt;

  Property.fromJson(Map<String, dynamic> json) {
    property_name = json['property_name'] ?? '';
    bedrooms = json['bedrooms'] ?? "0";
    bathrooms = json['bathrooms'] ?? "0";
    garages = json['garages'] ?? "0";
    area = json['area'] ?? "0";
    id = json['id'] ?? '';
    address = json['address'] ?? '';
    lat = json['lat'] ?? '';
    lon = json['lon'] ?? '';
    cost = json['cost'] ?? "0";
    showImg = json['showImg'] ?? '';
    yearBuilt = json['yearBuilt'] ?? '';
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
    _data['cost'] = cost;
    _data['showImg'] = showImg;
    _data['yearBuilt'] = yearBuilt;
    return _data;
  }
}
