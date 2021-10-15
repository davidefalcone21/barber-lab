// var submitData = {
//   'customerName': context.read(userInformation).state.name,
//   'customerPhone': FirebaseAuth.instance.currentUser.phoneNumber,
//   'barberName' : 'LorenzoStaff',
//   'done': false,
//   'slot': selectedTimeSlot,
//   'timeStamp' : timeStamp,
//   'time' : '${selectedTime} - ${DateFormat('dd/MM/yyy').format(selectedDate)}',
//   'note' : note,
// };

import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String docId, barberName, customerName, customerPhone, time, note;
  bool done;
  int slot, timeStamp;

  DocumentReference reference;

  BookingModel(
      {this.docId,
      this.barberName,
      this.customerName,
      this.customerPhone,
      this.time,
      this.done,
      this.slot,
      this.timeStamp,
      this.note});

  BookingModel.fromJson(Map<String, dynamic> json) {
    docId = json['docId'];
    barberName = json['barberName'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    time = json['time'];
    note = json['note'];
    done = json['done'] as bool;
    slot = int.parse(json['slot'] == null ? '-1' : json['slot'].toString());
    timeStamp = int.parse(
        json['timeStamp'] == null ? '-1' : json['timeStamp'].toString());
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
    data['timeStamp'] = this.timeStamp;

    return data;
  }
}
