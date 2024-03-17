import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Provider/user_provider.dart';
import 'package:uperitivo/Screens/Components/loader_splashscreen.dart';
import 'package:uperitivo/Screens/bottom_navigation.dart';
import 'package:uperitivo/SplashScreen.dart';
import 'package:uperitivo/Utils/helpers.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xffA04805),
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'UPERITIVO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder<UserModel?>(
          future: _getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              UserModel? user = snapshot.data;
              if (user != null) {
                updateCurrentUser(user, context);
                _getAllEventsForCompanies(context);
                return const BottomNavigation();
              } else {
                return SplashScreen();
              }
            } else {
              return LoaderSplashScreen();
            }
          },
        ),
      ),
    );
  }

  Future<UserModel?> _getUser() async {
    RegisterController registerController = RegisterController();
    return registerController.getSignedInUser();
  }

  Future<void> _getAllEventsForCompanies(BuildContext context) async {
    RegisterController registerController = RegisterController();
    await registerController.getAllEventsForCompanies(context);
  }
}
