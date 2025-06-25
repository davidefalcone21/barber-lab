import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barber_lab_sabatini/cloud_firestore/user_ref.dart';
import 'package:barber_lab_sabatini/model/booking_model.dart';
import 'package:barber_lab_sabatini/state/state_management.dart';
import 'package:barber_lab_sabatini/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StaffHistory extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => StaffHistoryPage();
}

class StaffHistoryPage extends ConsumerState<StaffHistory> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: true,
            body: Padding(
                padding: const EdgeInsets.all(12),
                child: displayStaffHistory())));
    throw UnimplementedError();
  }

  displayStaffHistory() {
    return FutureBuilder(
        future: getBarberHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var userBookings = snapshot.data as List<BookingModel>?;
            if (userBookings == null || userBookings.length == 0) {
              return Center(
                  child: Text(
                      'Impossibile caricare informazioni sulle prenotazioni'));
            } else {
              return FutureBuilder(
                  future: syncTime(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var syncTime = snapshot.data as DateTime;

                      return ListView.builder(
                          itemCount: userBookings.length,
                          itemBuilder: (context, index) {
                            var isExpired = DateTime.fromMillisecondsSinceEpoch(
                                    userBookings[index].timeStamp ?? 0)
                                .isBefore(syncTime);
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                              ),
                              child: Column(children: [
                                Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Data',
                                                  style: GoogleFonts.raleway(),
                                                ),
                                                Text(
                                                  DateFormat("dd/MM/yy").format(
                                                      DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              userBookings[
                                                                          index]
                                                                      .timeStamp ??
                                                                  0)),
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Orario',
                                                  style: GoogleFonts.raleway(),
                                                ),
                                                Text(
                                                  getTimeSlotListForDate(DateTime
                                                          .fromMillisecondsSinceEpoch(
                                                              userBookings[
                                                                          index]
                                                                      .timeStamp ??
                                                                  0))
                                                      .elementAt(
                                                          userBookings[index]
                                                                  .slot ??
                                                              0),
                                                  style: GoogleFonts.raleway(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  'Note',
                                                  style: GoogleFonts.raleway(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  'Nome',
                                                  style: GoogleFonts.raleway(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  'Servizio scelto',
                                                  style: GoogleFonts.raleway(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Center(
                                              child: Text(
                                                userBookings
                                                        .elementAt(index)
                                                        .note ??
                                                    'N/A',
                                                style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  userBookings
                                                          .elementAt(index)
                                                          .customerName ??
                                                      "customer_name",
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  userBookings
                                                          .elementAt(index)
                                                          .tipoServizio ??
                                                      "tipo_servizio",
                                                  style: GoogleFonts.raleway(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                GestureDetector(
                                  onTap: isExpired
                                      ? null
                                      : () {
                                          cancelBooking(
                                              context, userBookings[index]);
                                        },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: isExpired
                                              ? Colors.grey
                                              : Colors.redAccent,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(22),
                                            bottomRight: Radius.circular(22),
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                                isExpired
                                                    ? 'SCADUTO'
                                                    : 'CANCELLA',
                                                style: GoogleFonts.raleway(
                                                    color: Colors.white)),
                                          )
                                        ],
                                      )),
                                )
                              ]),
                            );
                          });
                    }
                  });
            }
          }
        });
  }

  void cancelBooking(BuildContext context, BookingModel bookingModel) {
    Alert(
        context: context,
        type: AlertType.warning,
        title: 'CANCELLA APPUNTAMENTO',
        desc:
            'Premendo su conferma, si desidera a procedere alla cancellazione della prenotazione. Si ignori pure l eventuale future notifica di reminder',
        buttons: [
          DialogButton(
              child: Text('ANNULLA'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          DialogButton(
              child: Text('CANCELLA'),
              onPressed: () {
                deleteFromDatabase(bookingModel);
              }),
        ]).show();
  }

  void deleteFromDatabase(BookingModel bookingModel) {
    final databaseReference = FirebaseFirestore.instance;

    var batch = FirebaseFirestore.instance.batch();

    var barberBookingSlot = databaseReference
        .collection('Barber')
        .doc('LorenzoStaff')
        .collection(
            '${DateFormat('dd_MM_yyyy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp ?? 0))}')
        .doc(bookingModel.slot.toString());

    var barberBooking = databaseReference
        .collection('Barber')
        .doc('LorenzoStaff')
        .collection('BookingStaff')
        .doc(bookingModel.docId.toString());

    var userBooking = bookingModel.reference;

    var realUserBooking = databaseReference
        .collection('User')
        .doc(bookingModel.customerPhone ??
            'unknown') // Provide a default value for null
        .collection(bookingModel.userCollection ??
            'default_collection') // Provide a default value for null
        .doc(bookingModel.docId ??
            'unknown'); // Provide a default value for null

    batch.delete(userBooking!);
    batch.delete(barberBooking);
    batch.delete(barberBookingSlot);
    batch.delete(realUserBooking);

    batch.commit().then((value) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      ScaffoldMessenger.of(scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text('Prenotazione Cancellata!')));
      ref.read(deleteFlagRefresh.notifier).state =
          !ref.read(deleteFlagRefresh.notifier).state;
    });
  }
}
