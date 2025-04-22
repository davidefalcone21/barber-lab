import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String? docId,
      barberName,
      customerName,
      customerPhone,
      time,
      note,
      tipoServizio,
      uuidLinkedHourBooking,
      userCollection;
  bool? done;
  int? slot, timeStamp, slotLinkedHourBooking;

  DocumentReference? reference;

  BookingModel(
      {this.docId,
      this.barberName,
      this.customerName,
      this.customerPhone,
      this.time,
      this.done,
      this.slot,
      this.timeStamp,
      this.note,
      this.tipoServizio,
      this.uuidLinkedHourBooking,
      this.slotLinkedHourBooking,
      this.userCollection});

  BookingModel.fromJson(Map<String, dynamic> json) {
    docId = json['docId']?.toString();
    barberName = json['barberName']?.toString();
    customerName = json['customerName']?.toString();
    customerPhone = json['customerPhone']?.toString();
    time = json['time']?.toString();
    note = json['note']?.toString();
    done = json['done'] is bool ? json['done'] : false;
    slot =
        json['slot'] != null ? int.tryParse(json['slot'].toString()) ?? -1 : -1;
    slotLinkedHourBooking = json['slotLinkedHourBooking'] != null
        ? int.tryParse(json['slotLinkedHourBooking'].toString()) ?? -1
        : -1;
    timeStamp = json['timeStamp'] != null
        ? int.tryParse(json['timeStamp'].toString()) ?? -1
        : -1;
    tipoServizio = json['tipoServizio']?.toString();
    uuidLinkedHourBooking = json['uuidHourBooking']?.toString();
    userCollection = json['userCollection']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docId'] = this.docId;
    data['barberName'] = this.barberName;
    data['customerName'] = this.customerName;
    data['customerPhone'] = this.customerPhone;
    data['time'] = this.time;
    data['note'] = this.note;
    data['slot'] = this.slot;
    data['slotLinkedHourBooking'] = this.slotLinkedHourBooking;
    data['timeStamp'] = this.timeStamp;
    data['tipoServizio'] = this.tipoServizio;
    data['uuidHourBooking'] = this.uuidLinkedHourBooking;
    data['userCollection'] = this.userCollection;

    return data;
  }
}
