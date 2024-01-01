import 'package:flutter/material.dart';
import 'package:uperitivo/Screens/UserAccount/login.dart';
import 'package:uperitivo/Screens/UserAccount/register_main.dart';
import 'package:uperitivo/Utils/helpers.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: getBackground(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 136,
                ),
                width: 311.69,
                height: 348.74,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Group_385.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5887DC),
                  fixedSize: const Size(167, 51),
                ),
                child: const Text(
                  'ENTRA',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      getScreen(context, () => const LoginScreen());
                    },
                    child: Column(
                      children: [
                        const Text(
                          'Accedi',
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 2.0,
                          width: 30.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      "o",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getScreen(context, () => const RegisterMain());
                    },
                    child: Column(
                      children: [
                        const Text(
                          'Registrati',
                          style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 2.0,
                          width: 50.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Registrandoti dichiari di avere almeno 18 anni!',
                style: TextStyle(
                  color: Color(0xFFF99600),
                ),
              ),
              const Spacer(),
              Container(
                width: 143,
                height: 40.18,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Group 133.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'by Earth, Wing & Foil',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
