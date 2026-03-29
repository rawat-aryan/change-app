import 'package:flutter/material.dart';
import 'study_screen.dart';
import 'fitness_screen.dart';
import 'tasks_screen.dart';
import '../widgets/module_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ModuleCard(
              title: "Study",
              icon: Icons.book,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudyScreen()),
                );
              },
            ),

            ModuleCard(
              title: "Fitness",
              icon: Icons.fitness_center,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FitnessScreen()),
                );
              },
            ),

            ModuleCard(
              title: "Tasks",
              icon: Icons.check_circle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TasksScreen()),
                );
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const LinearProgressIndicator(value: 0.3),
          ],
        ),
      ),
    );
  }
}
