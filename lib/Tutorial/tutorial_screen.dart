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
      backgroundColor: const Color(0xffF2F2F2),
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          Header(
            onIconTap: () {},
            onDrawerTap: () {
              _openDrawer();
            },
            screenName: "tutorial",
          ),
          Expanded(
            child: ListView(
              children: [
                buildImage("t1.png"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ContainerList(),
                ),
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

class ContainerList extends StatelessWidget {
  final List<String> names = [
    'Vino',
    'Spritz',
    'Bollicine',
    'Superalcolici',
    'Analcolico',
    'Street Food',
    'Vegano'
  ];
  final List<Color> colors = [
    Colors.brown,
    Colors.orange,
    Colors.yellow,
    Colors.blue,
    Colors.green,
    Colors.amber,
    Colors.greenAccent
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "CATEGORIE",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: names.sublist(0, 4).map((name) {
                  int index = names.indexOf(name);
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          color: colors[index],
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          name,
                          // style: TextStyle(color: colors[index]),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: names.sublist(4, 7).map((name) {
                  int index = names.indexOf(name);
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 20.0,
                          height: 20.0,
                          color: colors[index],
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          name,
                          // style: TextStyle(color: colors[index]),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
