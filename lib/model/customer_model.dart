class CustomerModel {
  CustomerModel(
      {required this.customer_name,
      required this.property_id,
      required this.agent_id,
      required this.phonenumber,
      required this.address,
      required this.customer_id});
  late String customer_name;
  late String property_id;
  late String agent_id;
  late String phonenumber;
  late String address;
  late String customer_id;

  CustomerModel.fromJson(Map<String, dynamic> json) {
    customer_name = json['customer_name'] ?? '';
    property_id = json['property_id'] ?? '';
    agent_id = json['agent_id'] ?? '';
    phonenumber = json['phonenumber'] ?? '';
    address = json['address'] ?? '';
    customer_id = json['customer_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['customer_name'] = customer_name;
    _data['property_id'] = property_id;
    _data['agent_id'] = agent_id;
    _data['phonenumber'] = phonenumber;
    _data['address'] = address;
    _data['customer_id'] = customer_id;
    return _data;
  }
}
