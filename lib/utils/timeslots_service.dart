import 'package:cloud_firestore/cloud_firestore.dart';

class TimeSlotService {
  /// this will hold your slots at runtime
  static List<String> slots = [
    '08:02 - 08:30',
    '08:30 - 09:00',
    '09:00 - 09:30',
    '09:30 - 10:00',
    '10:00 - 10:30',
    '10:30 - 11:00',
    '11:00 - 11:30',
    '11:30 - 12:00',
    '12:00 - 12:30',
    '12:30 - 13:00',
    '15:00 - 15:30',
    '15:30 - 16:00',
    '16:00 - 16:30',
    '16:30 - 17:00',
    '17:00 - 17:30',
    '17:30 - 18:00',
    '18:00 - 18:30',
    '18:30 - 19:00',
  ];

  static List<String> slots_new = [
    '08:02 - 08:30',
    '08:30 - 09:00',
    '09:00 - 09:30',
    '09:30 - 10:00',
    '10:00 - 10:30',
    '10:30 - 11:00',
    '11:00 - 11:30',
    '11:30 - 12:00',
    '12:00 - 12:30',
    '12:30 - 13:00',
    '15:00 - 15:30',
    '15:30 - 16:00',
    '16:00 - 16:30',
    '16:30 - 17:00',
    '17:00 - 17:30',
    '17:30 - 18:00',
    '18:00 - 18:30',
    '18:30 - 19:00',
  ];

  static DateTime newSlotsStartDate = DateTime(2025, 8, 1);

  static String hours = '08:00 - 13:00 / 15:00 - 19:00';

  /// call this *before* runApp(), once.
  static Future<void> init() async {
    final doc = await FirebaseFirestore.instance
        .collection('Settings')
        .doc('TimeSlots')
        .get();

    if (doc.exists && doc.data()!.containsKey('slots')) {
      // overwrite with whatever’s in Firestore
      slots = List<String>.from(doc['slots'] as List<dynamic>);
    }

    final docNew = await FirebaseFirestore.instance
        .collection('Settings')
        .doc('TimeSlotsNew')
        .get();

    if (docNew.exists && docNew.data()!.containsKey('slots')) {
      // overwrite with whatever’s in Firestore
      slots_new = List<String>.from(docNew['slots'] as List<dynamic>);
    }

    final switchDoc = await FirebaseFirestore.instance
        .collection('Settings')
        .doc('TimeSlotSwitch')
        .get();

    if (switchDoc.exists && switchDoc.data()!.containsKey('startDate')) {
      final raw = switchDoc['startDate'];
      if (raw is Timestamp) {
        newSlotsStartDate = raw.toDate();
      } else if (raw is String) {
        newSlotsStartDate = DateTime.tryParse(raw) ?? newSlotsStartDate;
      }
    }

    final doc2 = await FirebaseFirestore.instance
        .collection('Settings')
        .doc('OpeningHours')
        .get();

    if (doc2.exists && doc2.data()!.containsKey('hours')) {
      hours = doc2['hours'] as String;
    }
  }
}
