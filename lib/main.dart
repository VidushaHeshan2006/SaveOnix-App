import 'package:flutter/material.dart';
import 'Frontend/Screens/logo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Flow Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashPage(), // Your logo / splash screen
    );
  }
}