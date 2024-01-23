import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/UserAccount/login.dart';
import 'package:uperitivo/Screens/bottom_navigation.dart';
import 'package:uperitivo/SplashScreen.dart';
import 'package:uperitivo/Tutorial/tutorial_screen.dart';
import 'package:uperitivo/Utils/helpers.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = getCurrentUser(context);
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
              if (user != null)
                ListTile(
                  title: const Center(
                    child: Text(
                      'Visualizza tutti gli eventi',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    if (context.mounted) {
                      getScreen(context, () => const BottomNavigation(),
                          removePreviousScreens: true);
                    }
                  },
                ),
              if (user != null) const Divider(),
              ListTile(
                title: const Center(
                  child: Text(
                    'Tutorial',
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  getScreen(
                    context,
                    () => TutorialScreen(),
                  );
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
                onTap: () {
                  if (context.mounted) {
                    getScreen(context, () => const LoginScreen(),
                        removePreviousScreens: true);
                  }
                },
              ),
              const Divider(),
              if (user != null)
                ListTile(
                  title: const Center(
                    child: Text(
                      'LOGOUT',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    await RegisterController().signOut(context);
                    if (context.mounted) {
                      getScreen(context, () => SplashScreen(),
                          removePreviousScreens: true);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
