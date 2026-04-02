import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'session_details_screen.dart';

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
    String note = "";

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

              TextField(
                decoration: const InputDecoration(
                  labelText: "Notes",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => note = value,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (duration.isEmpty ||
                        int.tryParse(duration) == null ||
                        int.parse(duration) <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fill all required fields"),
                        ),
                      );
                      return;
                    }
                    sessions.add({
                      "name": "Session ${sessions.length + 1}",
                      "duration": duration,
                      "date": DateTime.now().toString(),
                      "note": note,
                    });

                    saveData();
                    loadData();

                    Navigator.pop(context);
                  },
                  child: const Text("Add Session"),
                ),
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
                    title: Text(item["name"]),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${item["duration"]} min"),
                        if ((item["note"] ?? "").isNotEmpty)
                          Text("📝 ${item["note"]}"),
                        Text(
                          item["date"].toString().split(
                            " ",
                          )[0], // show date only
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SessionDetailScreen(session: item),
                        ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete Session"),
                            content: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  sessions.removeAt(index);
                                  saveData();
                                  loadData();
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
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
