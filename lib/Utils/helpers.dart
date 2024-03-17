import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Provider/user_provider.dart';
import 'package:intl/intl.dart';

import 'dart:math';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371;

  double radians(double degree) {
    return degree * (pi / 180.0);
  }

  double dLat = radians(lat2 - lat1);
  double dLon = radians(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(radians(lat1)) * cos(radians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = earthRadius * c;

  return distance;
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.green,
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message, [String? title]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    ),
  );
}

void getScreen(
  BuildContext context,
  Widget Function() screenBuilder, {
  bool removePreviousScreens = false,
  bool pushReplacement = false,
}) {
  PageRouteBuilder buildPageRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  if (removePreviousScreens) {
    Navigator.of(context).pushAndRemoveUntil(
      buildPageRoute(screenBuilder()),
      (Route<dynamic> route) => false,
    );
  } else if (pushReplacement) {
    Navigator.of(context).pushReplacement(buildPageRoute(screenBuilder()));
  } else {
    Navigator.of(context).push(buildPageRoute(screenBuilder()));
  }
}

BoxDecoration getBackground() {
  return const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background_main.png'),
      fit: BoxFit.cover,
    ),
  );
}

void updateCurrentUser(UserModel user, BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.updateCurrentUser(user);
}

void updateAllEventsForCompanies(
    Map<String, List<EventModel>> eventsMap, BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.companyEventsMap = eventsMap;
}

UserModel? getCurrentUser(BuildContext? context) {
  final userProvider = Provider.of<UserProvider>(context!, listen: false);
  return userProvider.currentUser;
}

List<EventModel> getAllEventsList(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  return userProvider.getAllCompanyEvents();
}

List<EventModel>? getCurrentUserEventsList(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  return userProvider.getcurrentUserEvents();
}

String formatItalianDate(String inputDate) {
  DateTime date = DateFormat('dd/MM/yyyy').parse(inputDate);

  // Define maps for English to Italian conversion
  Map<String, String> dayTranslations = {
    'Monday': 'Lunedì',
    'Tuesday': 'Martedì',
    'Wednesday': 'Mercoledì',
    'Thursday': 'Giovedì',
    'Friday': 'Venerdì',
    'Saturday': 'Sabato',
    'Sunday': 'Domenica',
  };

  Map<String, String> monthTranslations = {
    'January': 'Gen',
    'February': 'Feb',
    'March': 'Mar',
    'April': 'Apr',
    'May': 'Mag',
    'June': 'Giu',
    'July': 'Lug',
    'August': 'Ago',
    'September': 'Set',
    'October': 'Ott',
    'November': 'Nov',
    'December': 'Dic',
  };

  // Format the date in the desired output format with Italian names
  String formattedDate =
      '${dayTranslations[DateFormat('EEEE').format(date)]} ${date.day} ${monthTranslations[DateFormat('MMMM').format(date)]}';

  return formattedDate;
}

bool isEventOpen(
    String eventType, String eventTime, String untilDate, String eventDate) {
  String date = "";

  if (eventType == "recurring") {
    date = untilDate;
  } else {
    date = eventDate;
  }

  return isEventDateTimeValid(date, eventTime);
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String formatTime(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

bool isEventDateTimeValid(String eventDate, String eventTime) {
  // Parse date string
  List<String> dateParts = eventDate.split('/');
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);

  List<String> timeParts = eventTime.split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  DateTime eventDateTime = DateTime(year, month, day, hour, minute);

  DateTime currentDateTime = DateTime.now();
  return !(eventDateTime.isBefore(currentDateTime) ||
      eventDateTime.isAtSameMomentAs(currentDateTime));
}
