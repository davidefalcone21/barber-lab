
import 'package:ntp/ntp.dart';

enum LOGIN_STATE {LOGGED, NOT_LOGGED}

const TIME_SLOT = {
  '10:00 - 10:30',
  '10:30 - 11:00',
  '11:00 - 11:30',
  '11:30 - 12:00',
  '12:00 - 12:30',
  '12:30 - 13:00',
  '13:00 - 13:30',
  '13:30 - 14:00',
  '14:00 - 14:30',
  '14:30 - 15:00',
  '15:00 - 15:30',
  '15:30 - 16:00',
  '16:00 - 16:30',
  '16:30 - 17:00',
  '17:00 - 17:30',
  '17:30 - 18:00',
  '18:00 - 18:30',
  '18:30 - 19:00',
};

Future<DateTime> syncTime() async{
  var now = DateTime.now();
  var offset = await NTP.getNtpOffset(localTime: now);
  return now.add(Duration(milliseconds: offset));
}