import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/Components/cTBTextField.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/footer.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Screens/UserAccount/forgot_password.dart';
import 'package:uperitivo/Screens/bottom_navigation.dart';
import 'package:uperitivo/Utils/helpers.dart';

class LoginScreen extends StatefulWidget {
  final bool? isFromInside;
  final VoidCallback? onPop;

  const LoginScreen({Key? key, this.isFromInside, this.onPop})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  bool isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    // usernameController.text = "user@gmail.com";
    // passwordController.text = "123456";
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          Header(
            onIconTap: () {},
            onDrawerTap: () {
              _openDrawer();
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Login',
              style: TextStyle(
                color: Color(0xFFA04805),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CTBTextField(
                      hintText: "e-mail",
                      controller: usernameController,
                    ),
                    const SizedBox(height: 16),
                    CTBTextField(
                      hintText: "Password",
                      controller: passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        text: 'Hai dimenticato le tue ',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: 'credenziali',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                getScreen(
                                    context, () => ForgotPasswordScreen());
                              },
                          ),
                          const TextSpan(
                            text: '?',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Registrandoti dichiari di avere almeno 18 anni !',
                      style: TextStyle(fontSize: 14, color: Color(0xFFF99600)),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoggingIn
                            ? null
                            : () async {
                                setState(() {
                                  isLoggingIn = true;
                                });

                                RegisterController registerController =
                                    RegisterController();
                                String email = usernameController.text
                                    .trim()
                                    .toLowerCase();
                                String password = passwordController.text;
                                if (email.isNotEmpty && password.isNotEmpty) {
                                  UserModel? user = await registerController
                                      .signInWithEmailAndPassword(
                                          email, password);

                                  if (user != null) {
                                    if (context.mounted) {
                                      updateCurrentUser(user, context);
                                      await registerController
                                          .getAllEventsForCompanies(context);
                                    }
                                    if (mounted) {
                                      if (widget.isFromInside != null) {
                                        if (widget.onPop != null) {
                                          widget.onPop!();
                                        }
                                        Navigator.pop(context);
                                      } else {
                                        getScreen(context,
                                            () => const BottomNavigation(),
                                            removePreviousScreens: true);
                                      }
                                    }
                                  } else {
                                    if (mounted) {
                                      showErrorSnackBar(context,
                                          "Invalid username or password");
                                    }
                                  }
                                } else {
                                  showErrorSnackBar(
                                      context, "Fill both fields");
                                }

                                setState(() {
                                  isLoggingIn = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5887DC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          child: isLoggingIn
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text(
                                  'ACCEDI',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Footer()
        ],
      ),
      endDrawer: const DrawerScreen(),
    );
  }
}
