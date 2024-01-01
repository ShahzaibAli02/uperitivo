import 'package:flutter/material.dart';
import 'package:uperitivo/SplashScreen.dart';
import 'package:uperitivo/Utils/helpers.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            getScreen(context, () => SplashScreen(),
                removePreviousScreens: true);
          },
          child: Image.asset("assets/images/home_icon.png"),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'UPERITIVO® by Earth, Wing & Foil',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
