import 'dart:async';
import 'package:flutter/material.dart';
import '../styles/logo_styles.dart';
import 'welcome_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();


    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppStyles.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Images/logo.png',
              width: 400,
            ),
            const SizedBox(height: 20),
            const Text(
              'SaveOnix',
              style: AppStyles.titleText,
              
            ),
            const SizedBox(height: 8),
            const Text(
              'Smart, Simple, Secure',
              style: AppStyles.subtitleText,
            ),
          ],
        ),
      ),
    );
  }
}
