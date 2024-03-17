import 'package:flutter/material.dart';
import 'package:uperitivo/SplashScreen.dart';
import 'package:uperitivo/Utils/helpers.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                getScreen(context, () => SplashScreen(),
                    removePreviousScreens: true);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset("assets/images/home.png"),
              ),
            ),
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
      ),
    );
  }
}
