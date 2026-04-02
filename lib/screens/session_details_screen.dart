import 'package:flutter/material.dart';

class SessionDetailScreen extends StatelessWidget {
  final Map session;

  const SessionDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Session Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Duration: ${session["duration"]} min",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            Text(
              "Date: ${session["date"]}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            Text("Notes:", style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Text(session["note"] ?? "No notes added"),
          ],
        ),
      ),
    );
  }
}
