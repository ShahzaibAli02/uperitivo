import 'package:flutter/material.dart';
import 'package:uperitivo/Tutorial/tutorial_screen.dart';
import 'package:uperitivo/Utils/helpers.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              ListTile(
                title: const Center(
                  child: Text(
                    'Visualizza tutti gli eventi',
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                title: const Center(
                  child: Text(
                    'Tutorial',
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  getScreen(context, () => TutorialScreen());
                },
              ),
              const Divider(),
              ListTile(
                title: const Center(
                  child: Text(
                    'Login',
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                title: const Center(
                  child: Text(
                    'LOGOUT',
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
