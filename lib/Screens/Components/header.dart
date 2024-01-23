import 'package:flutter/material.dart';
import 'package:uperitivo/Tutorial/tutorial_screen.dart';
import 'package:uperitivo/Utils/helpers.dart';

class Header extends StatelessWidget {
  final VoidCallback onIconTap;
  final VoidCallback onDrawerTap;
  final String screenName;

  const Header({
    Key? key,
    required this.onIconTap,
    required this.onDrawerTap,
    this.screenName = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double headerHeight = MediaQuery.of(context).size.height * 0.2126;

    return Container(
      height: headerHeight,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/header light.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: screenName == "tutorial"
                ? null
                : () {
                    getScreen(context, () => TutorialScreen());
                  },
            child: Ink(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the value as needed
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/info.png',
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          ),
          Image.asset(
            'assets/images/header_logo.png',
            width: 199.88,
            height: 90.21,
          ),
          InkWell(
            onTap: onDrawerTap,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/bars.png',
                  width: 24,
                  height: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
