import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ChangeApp());
}

class ChangeApp extends StatelessWidget {
  const ChangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
