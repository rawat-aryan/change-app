import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'topic_screen.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final box = Hive.box('studyBox');

  List subjects = [];

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  void loadSubjects() {
    final data = box.get('subjects', defaultValue: []);
    setState(() {
      subjects = List.from(data);
    });
  }

  void saveSubjects() {
    box.put('subjects', subjects);
  }

  void addSubject(String name) {
    subjects.add({"name": name, "topics": []});

    saveSubjects();
    loadSubjects();
  }

  void showAddSubjectDialog() {
    String subjectName = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Subject"),
          content: TextField(
            decoration: const InputDecoration(labelText: "Subject Name"),
            onChanged: (value) => subjectName = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (subjectName.isNotEmpty) {
                  addSubject(subjectName);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subjects")),

      body: subjects.isEmpty
          ? const Center(child: Text("No subjects yet"))
          : ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];

                return ListTile(
                  title: Text(subject["name"]),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TopicScreen(subjectIndex: index),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Subject"),
                          content: const Text("Are you sure?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                subjects.removeAt(index);
                                saveSubjects();
                                loadSubjects();
                                Navigator.pop(context);
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddSubjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
