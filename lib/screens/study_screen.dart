import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final box = Hive.box('studyBox');

  List sessions = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // 🔥 Load data
  void loadData() {
    final data = box.get('sessions', defaultValue: []);
    setState(() {
      sessions = List.from(data);
    });
  }

  // 🔥 Save data
  void saveData() {
    box.put('sessions', sessions);
  }

  // 🔥 Add Session UI (Bottom Sheet)
  void showAddSheet() {
    String subject = "";
    String topic = "";
    String duration = "30";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Study Session",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // Subject
              TextField(
                decoration: const InputDecoration(labelText: "Subject"),
                onChanged: (value) => subject = value,
              ),

              // Topic
              TextField(
                decoration: const InputDecoration(labelText: "Topic"),
                onChanged: (value) => topic = value,
              ),

              const SizedBox(height: 10),
              const Text("Duration (minutes)"),

              // Quick duration options
              Wrap(
                spacing: 10,
                children: ["15", "30", "45", "60"].map((d) {
                  return ChoiceChip(
                    label: Text(d),
                    selected: duration == d,
                    onSelected: (_) {
                      setState(() {
                        duration = d;
                      });
                    },
                  );
                }).toList(),
              ),

              // Custom duration
              TextField(
                decoration: const InputDecoration(
                  labelText: "Custom (>60 min)",
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) duration = value;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (subject.isNotEmpty && topic.isNotEmpty) {
                    // 🔥 Generic structure (important)
                    sessions.add({
                      "title": "Study Session",
                      "fields": {
                        "subject": subject,
                        "topic": topic,
                        "duration": duration,
                      },
                      "date": DateTime.now().toString(),
                    });

                    saveData();
                    loadData();

                    Navigator.pop(context);
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Study Tracker")),

      body: sessions.isEmpty
          ? const Center(child: Text("No study sessions yet"))
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final item = sessions[index];
                final fields = item["fields"] ?? item;

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(fields["subject"].toString()),
                    subtitle: Text(
                      "${fields["topic"]} • ${fields["duration"]} min",
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
