class AgentModel {
  AgentModel({
    required this.agent_name,
    required this.age,
    required this.phone_number,
    required this.address,
    required this.id,
  });
  late String agent_name;
  late String age;
  late String phone_number;
  late String address;
  late String id;

  AgentModel.fromJson(Map<String, dynamic> json) {
    agent_name = json['agent_name'] ?? '';
    age = json['age'] ?? '';
    phone_number = json['phone_number'] ?? '';
    address = json['address'] ?? '';
    id = json['id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['agent_name'] = agent_name;
    _data['age'] = age;
    _data['phone_number'] = phone_number;
    _data['address'] = address;
    _data['id'] = id;

    return _data;
  }
}
