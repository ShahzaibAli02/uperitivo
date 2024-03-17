import 'package:flutter/material.dart';

class LoaderSplashScreen extends StatelessWidget {
  const LoaderSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      ),
    );
  }
}
