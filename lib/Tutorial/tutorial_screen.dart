import 'package:flutter/material.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/header.dart';

class TutorialScreen extends StatelessWidget {
  TutorialScreen({super.key});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          Header(
            onIconTap: () {},
            onDrawerTap: () {
              _openDrawer();
            },
          ),
          Expanded(
            child: ListView(
              children: [
                buildImage("t1.png"),
                buildImage("t2.png"),
                buildImage("t3.png"),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: buildImage("t4.png"),
                ),
              ],
            ),
          ),
        ],
      ),
      endDrawer: const DrawerScreen(),
    );
  }

  Widget buildImage(String imageName) {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
        "assets/images/$imageName",
        fit: BoxFit.contain,
      ),
    );
  }
}
