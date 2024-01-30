import 'package:flutter/material.dart';

class LoaderSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
