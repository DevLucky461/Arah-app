import 'dart:math';
import 'dart:ui';

import 'package:arah_app/language/languages.dart';
import 'package:arah_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math.dart';

const Color arah_white = const Color(0xFFFFFFFF);
const Color color_primary = const Color(0xFF38B9A1);
const Color color_second = const Color(0xFF006B8E);
const Color color_background = const Color(0xFFEBEBEB);
const Color color_grey_divider = const Color(0xFFEDEDED);
const Color color_dark_grey = const Color(0xFF454545);
const Color color_light_grey = const Color(0xFF828282);
const Color color_shadow = const Color(0xFFCCCCCC);
const Color color_nu_grey = const Color(0xFFE4E4E4);
const Color color_nav_start = const Color(0xFFEAEAEA);
const Color color_nav_end = const Color(0xFFE9E9E9);
const Color color_nav_border = const Color(0xFF6C6C6C);

String channel = 'https://staging-socket.arahglobal.com';

String BASEURL = 'https://dev.arahglobal.com/';
// String BASEURL = 'https://staging.arahglobal.com/';
// String BASEURL = 'http://192.168.108.181:8000/';

const AndroidNotificationChannel notificationChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

User user = new User();

Widget SizeArah(double height, [double width = 0]) {
  return SizedBox(
    height: height,
    width: width,
  );
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

showStep(int step, int total) {
  List<Widget> lst = [];
  for (int i = 0; i < total; i++)
    lst.add(Container(
      decoration: BoxDecoration(
        color: i == step ? Color(0xFFFFFFFF) : Color(0x3FFFFFFF),
        shape: BoxShape.circle,
      ),
      height: 8,
      width: 12,
    ));
  return lst;
}

Widget getBottomBarText(String text, bool selected) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.lato(color: selected ? color_primary : Color(0xff000000), fontSize: 11),
  );
}

Widget TextArah(String text) {
  return Text(
    text,
    style: GoogleFonts.lato(fontSize: 25, fontWeight: FontWeight.w900),
  );
}

Widget TextArahContent(String text) {
  return Text(
    text,
    style: GoogleFonts.lato(fontSize: 18, color: color_dark_grey),
  );
}

Widget TextArahDescription(String text) {
  return Text(
    text,
    style: GoogleFonts.lato(fontSize: 15, color: color_dark_grey),
  );
}

String getFormattedAmount(String amount) {
  double amt = 0.0;
  if (amount.contains(".")) {
    List<String> lst = amount.split('.');
    amount = lst[0];
  }

  if (amount == null || amount == "") {
    return "0";
  } else {
    amt = double.parse(amount);
  }
  NumberFormat formatter = NumberFormat('#,###,000');
  return formatter.format(amt);
}

navigateTo(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => page));
}

showToast(String text) {
  return Fluttertoast.showToast(msg: text);
}

Widget divider() {
  return Divider(
    color: Color(0xFFF2F2F2),
    thickness: 1,
  );
}

String getDateTimeFromGMT(BuildContext context, String time) {
  if (time == null || time == '') {
    return "";
  }

  DateTime now = DateTime.now();
  DateTime dateTime = DateTime.parse(time);
  dateTime = dateTime.add(now.timeZoneOffset);

  if (dateTime.year < now.year || dateTime.month < now.month || dateTime.day < now.day - 1)
    return DateFormat('d MMM yyyy').format(dateTime);
  else if (dateTime.day == now.day - 1)
    return Languages.of(context).Yesterday;
  else
    return DateFormat('hh:mm a').format(dateTime);
}

String getTimeFromGMT(String time) {
  if (time == null || time == '') {
    return "";
  }

  DateTime dateTime = DateTime.parse(time);
  dateTime = dateTime.add(DateTime.now().timeZoneOffset);

  return DateFormat('hh:mm a').format(dateTime);
}

String getDateFromGMT(String time) {
  if (time == null || time == '') {
    return "";
  }

  DateTime dateTime = DateTime.parse(time);
  dateTime = dateTime.add(DateTime.now().timeZoneOffset);

  return DateFormat("d MMMM yyyy").format(dateTime);
}

String getScheduleGMT(String time) {
  if (time == null || time == '') {
    return "";
  }

  DateTime dateTime = DateTime.parse(time);
  dateTime = dateTime.subtract(dateTime.timeZoneOffset);

  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  return formatter.format(dateTime);
}

String getDatabaseDateTime(String time) {
  if (time == null || time == '') {
    return "";
  }

  DateTime dateTime = DateTime.parse(time);
  dateTime = dateTime.subtract(dateTime.timeZoneOffset);

  DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'");

  return formatter.format(dateTime);
}

String getDateInDDMMMYYYYHHSS(String time) {
  if (time == null || time == '') {
    return "";
  }

  DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(time);
  DateFormat formatter = DateFormat('dd MMM, yyyy hh:mm a');
  final String formatted = formatter.format(tempDate);

  return formatted;
}

double getOffsetFromNorth(double currentLatitude, double currentLongitude, double targetLatitude,
    double targetLongitude) {
  double la_rad = radians(currentLatitude);
  double lo_rad = radians(currentLongitude);

  double de_la = radians(targetLatitude);
  double de_lo = radians(targetLongitude);

  double toDegrees = degrees(atan(
      sin(de_lo - lo_rad) / ((cos(la_rad) * tan(de_la)) - (sin(la_rad) * cos(de_lo - lo_rad)))));
  if (la_rad > de_la) {
    if ((lo_rad > de_lo || lo_rad < radians(-180.0) + de_lo) &&
        toDegrees > 0.0 &&
        toDegrees <= 90.0) {
      toDegrees += 180.0;
    } else if (lo_rad <= de_lo &&
        lo_rad >= radians(-180.0) + de_lo &&
        toDegrees > -90.0 &&
        toDegrees < 0.0) {
      toDegrees += 180.0;
    }
  }
  if (la_rad < de_la) {
    if ((lo_rad > de_lo || lo_rad < radians(-180.0) + de_lo) &&
        toDegrees > 0.0 &&
        toDegrees < 90.0) {
      toDegrees += 180.0;
    }
    if (lo_rad <= de_lo &&
        lo_rad >= radians(-180.0) + de_lo &&
        toDegrees > -90.0 &&
        toDegrees <= 0.0) {
      toDegrees += 180.0;
    }
  }
  return toDegrees;
}

String getImage(String image) {
  return BASEURL + image;
}

bool checkForLink(String msg) {
  return msg.contains('http://') || msg.contains('https://') || msg.contains('www.');
}

Future<PermissionStatus> getPermission() async {
  final PermissionStatus permission = await Permission.contacts.status;
  print(permission);
  if (permission != PermissionStatus.granted && permission != PermissionStatus.denied) {
    final Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.contacts].request();
    return permissionStatus[Permission.contacts] ?? PermissionStatus.restricted;
  } else {
    return permission;
  }
}

List<String> occupationList = [
  "Accountant",
  "Actor / Actress",
  "Architect",
  "Author",
  "Baker",
  "Bricklayer",
  "Bus driver",
  "Butcher",
  "Carpenter",
  "Chef/Cook",
  "Cleaner",
  "Dentist",
  "Designer",
  "Doctor",
  "Dustman/Refuse collector",
  "Electrician",
  "Factory worker",
  "Farmer",
  "Fireman/Fire fighter",
  "Fisherman",
  "Florist",
  "Gardener",
  "Hairdresser",
  "Journalist",
  "Judge",
  "Lawyer",
  "Lecturer ",
  "Librarian",
  "Lifeguard",
  "Mechanic",
  "Model",
  "Newsreader",
  "Nurse",
  "Optician",
  "Painter",
  "Pharmacist",
  "Photographer",
  "Pilot",
  "Plumber",
  "Politician",
  "Policeman/Policewoman",
  "Postman",
  "Real estate agent",
  "Receptionist ",
  "Scientist",
  "Secretary",
  "Shop assistant",
  "Soldier",
  "Software Engineer",
  "Tailor",
  "Taxi driver",
  "Teacher",
  "Translator",
  "Traffic warden",
  "Travel agent",
  "Veterinary doctor (Vet)",
  "Waiter/Waitress"
];

List<String> incomeList = [
  "< 14,000,000",
  "14,000,000 ~ 42,000,000",
  "42,000,000 ~ 70,000,000",
  "70,000,000 ~ 140,000,000",
  "140,000,000 ~ 281,000,000",
  "281,000,000 ~ 422,000,000",
  "422,000,000 ~ 704,000,000",
  "> 704,000,000"
];

List<String> stateList = [
  "Aceh",
  "Bali",
  "Bangka-Belitung",
  "Banten",
  "Bengkulu",
  "Central Java",
  "Central Sulawesi",
  "Daerah Istimewa Yogyakarta",
  "East Java",
  "East Kalimantan",
  "East Nusa Tenggara",
  "Gorontalo",
  "Jakarta Raya",
  "Jambi",
  "Kalimantan Tengah",
  "Lampung",
  "Maluku",
  "Maluku Utara",
  "North Sulawesi",
  "North Sumatra",
  "Nusa Tenggara Barat",
  "Papua",
  "Riau",
  "Riau Islands",
  "South Kalimantan",
  "South Sulawesi",
  "South Sumatra",
  "Sulawesi Barat",
  "Sulawesi Tenggara",
  "West Java",
  "West Kalimantan",
  "West Papua",
  "West Sumatra",
  "Others"
];
