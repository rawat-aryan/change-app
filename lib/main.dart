import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('studyBox');

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
