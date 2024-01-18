import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Provider/user_provider.dart';
import 'package:intl/intl.dart';

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
  if (removePreviousScreens) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screenBuilder()),
      (Route<dynamic> route) => false,
    );
  } else {
    if (pushReplacement) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => screenBuilder(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => screenBuilder(),
        ),
      );
    }
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

UserModel? getCurrentUser(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  return userProvider.currentUser;
}

List<EventModel>? getAllEventsList(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  return userProvider.getAllCompanyEvents();
}

List<EventModel>? getCurrentUserEventsList(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  return userProvider.getcurrentUserEvents();
}

String formatItalianDate(String inputDate) {
  print(inputDate);
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

bool isEventOpen(String eventType, String untilDate, String eventDate) {
  String date = "";

  if (eventType == "recurring") {
    date = untilDate;
  } else {
    date = eventDate;
  }

  // DateTime eventDateTime = DateFormat("yyyy-MM-dd");
  // var now = new DateTime.now();
  // DateTime currentDateTime = DateFormat("yyyy-MM-dd").format(now);

  return true;
}
