import 'package:barber_lab_sabatini/model/booking_model.dart';
import 'package:barber_lab_sabatini/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barber_lab_sabatini/state/state_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'dart:developer' as developer;

import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<UserModel> getUserProfiles(
    BuildContext context, WidgetRef ref, String phone) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshot = await userRef.doc(phone).get();
  if (snapshot.exists) {
    var userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    ref.read(userInformation.notifier).state = userModel;
    return userModel;
  } else {
    return UserModel(); //return empty user
  }
}

Future<UserModel> getUserProfilesLogin(
    BuildContext context, WidgetRef ref, String phone) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshot = await userRef.doc(phone).get();
  if (snapshot.exists) {
    var userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    ref.read(userInformation.notifier).state = userModel;
    return userModel;
  } else {
    return UserModel(); //return empty user
  }
}

Future<Map<String, dynamic>> getTimeSlotLorenzo(String date) async {
  final databaseReference = FirebaseFirestore.instance;

  Map<String, dynamic> result = {
    'ferie': false,
    'slots': List<int>.empty(growable: true),
  };

  //if the selected date is in the collection ferie, we treat it as a day with all timeslots occupied
  var ferieRef = databaseReference.collection('Ferie');
  var doc = await ferieRef.doc(date).get();
  if (doc.exists) {
    result['ferie'] = true;
    for (int i = 0; i < 20; i++) {
      result['slots'].add(i);
    }
    return result;
  }

  var bookingRef = databaseReference
      .collection('Barber')
      .doc('LorenzoStaff')
      .collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    developer.log('log 1 ${element}');
    result['slots'].add(int.parse(element.id));
    developer.log('log 2 ${element.id}');
    developer.log('log 3 ${result}');
  });
  return result;
}

Future<List<BookingModel>> getUserHistory() async {
  try {
    print(
        'Phone: ${FirebaseAuth.instance.currentUser?.phoneNumber}, UID: ${FirebaseAuth.instance.currentUser?.uid}');

    var listBooking = <BookingModel>[];
    var userRef = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.phoneNumber)
        .collection('Booking_${FirebaseAuth.instance.currentUser?.uid}')
        .limit(20);

    var snapshot = await userRef.orderBy('timeStamp', descending: true).get();
    print('Fetched ${snapshot.docs.length} bookings');

    for (var element in snapshot.docs) {
      try {
        var booking = BookingModel.fromJson(element.data());
        booking.docId = element.id;
        booking.reference = element.reference;
        listBooking.add(booking);
      } catch (e, stack) {
        print('Error parsing booking: $e');
        print(stack);
      }
    }

    print('Returning listBooking with ${listBooking.length} items');
    return listBooking;
  } catch (e, stack) {
    print('Error in getUserHistory: $e');
    print(stack);
    return [];
  }
}

Future<List<BookingModel>> getUserHistoryOLd() async {
  var listBooking = new List<BookingModel>.empty(growable: true);
  var userPhone = FirebaseAuth.instance.currentUser?.phoneNumber;
  var userUid = FirebaseAuth.instance.currentUser?.uid;

  print('Phone: $userPhone, UID: $userUid');
  var userRef = FirebaseFirestore.instance
      .collection('User')
      .doc(FirebaseAuth.instance.currentUser?.phoneNumber)
      .collection('Booking_${FirebaseAuth.instance.currentUser?.uid}')
      .limit(20);

  var snapshot = await userRef.orderBy('timeStamp', descending: true).get();
  print('Fetched ${snapshot.docs.length} bookings');

  snapshot.docs.forEach((element) {
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  });
  print('Returning listBooking with ${listBooking.length} items');

  return listBooking;
}

Future<List<BookingModel>> getBarberHistory() async {
  var listBooking = new List<BookingModel>.empty(growable: true);
  var userRef = FirebaseFirestore.instance
      .collection('Barber')
      .doc('LorenzoStaff')
      .collection('BookingStaff')
      .limit(250);

  var snapshot = await userRef.orderBy('timeStamp', descending: true).get();
  snapshot.docs.forEach((element) {
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  });
  return listBooking;
}
