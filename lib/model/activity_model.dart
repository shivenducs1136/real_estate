class ActivityModel {
  ActivityModel({
    required this.code,
    required this.property_id,
    required this.agent_id,
    required this.customer_id,
    required this.msg,
    required this.isAdmin,
    required this.dateTime,
  });
  late String code;
  late String property_id;
  late String agent_id;
  late String customer_id;
  late String msg;
  late bool isAdmin;
  late String dateTime;

  ActivityModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? '';
    property_id = json['property_id'] ?? '';
    agent_id = json['agent_id'] ?? '';
    customer_id = json['customer_id'] ?? '';
    msg = json['msg'] ?? '';
    isAdmin = json['isAdmin'] ?? false;
    dateTime = json['dateTime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['msg'] = msg;
    _data['customer_id'] = customer_id;
    _data['agent_id'] = agent_id;
    _data['property_id'] = property_id;
    _data['isAdmin'] = isAdmin;
    _data['dateTime'] = dateTime;

    return _data;
  }
}
