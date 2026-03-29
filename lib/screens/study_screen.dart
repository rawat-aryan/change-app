import 'package:flutter/material.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Study Tracker")),
      body: const Center(
        child: Text("No study sessions yet", style: TextStyle(fontSize: 18)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
