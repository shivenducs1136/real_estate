class AgentModel {
  AgentModel(
      {required this.agent_name,
      required this.age,
      required this.phone_number,
      required this.address,
      required this.id,
      required this.photo});
  late String agent_name;
  late String age;
  late String phone_number;
  late String address;
  late String id;
  late String photo;

  AgentModel.fromJson(Map<String, dynamic> json) {
    agent_name = json['agent_name'] ?? '';
    age = json['age'] ?? '';
    phone_number = json['phone_number'] ?? '';
    address = json['address'] ?? '';
    id = json['id'] ?? '';
    photo = json['photo'] ??
        'https://th.bing.com/th/id/OIP.tWwHa21PC-F18kRm0I2w7wHaHa?pid=ImgDet&rs=1';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['agent_name'] = agent_name;
    _data['age'] = age;
    _data['phone_number'] = phone_number;
    _data['address'] = address;
    _data['id'] = id;
    _data['photo'] = photo;

    return _data;
  }
}
