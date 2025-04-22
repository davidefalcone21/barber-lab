import 'package:cloud_firestore/cloud_firestore.dart';

class BarberModel {
  String? name;
  DocumentReference? reference;

  BarberModel(this.name);

  BarberModel.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
