class ImageModel {
  ImageModel({required this.image});
  late String image;

  ImageModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? 'https://plchldr.co/i/336x280';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;

    return _data;
  }
}
