class UserModel {
  String? name, address;
  bool isStaff;

  UserModel({this.name, this.address, this.isStaff = false});

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name']?.toString(),
        address = json['address']?.toString(),
        isStaff = json['isStaff'] is bool ? json['isStaff'] as bool : false;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'isStaff': isStaff,
    };
  }
}
