import 'package:flutter/material.dart';

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
