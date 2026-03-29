import 'package:flutter/material.dart';

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fitness Tracker")),
      body: const Center(child: Text("No workouts logged")),
    );
  }
}
