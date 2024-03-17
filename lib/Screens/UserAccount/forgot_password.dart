import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Utils/helpers.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController emailController = TextEditingController();

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Center(
                        child: Text(
                          "Inserisci qui l'email usata in fase di registrazione:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff5887DC),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    String email = emailController.text.trim();
                    if (email.isNotEmpty) {
                      RegisterController()
                          .sendPasswordResetEmail(email, context);
                    } else {
                      showErrorSnackBar(
                          context, "Inserisci la tua email registrata");
                    }
                  },
                  child: const Text('Invia'),
                ),
              ],
            ),
          )
        ],
      ),
      endDrawer: const DrawerScreen(),
    );
  }
}
