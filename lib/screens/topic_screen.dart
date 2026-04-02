import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'study_screen.dart';

class TopicScreen extends StatefulWidget {
  final int subjectIndex;

  const TopicScreen({super.key, required this.subjectIndex});

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final box = Hive.box('studyBox');

  List subjects = [];
  List topics = [];

  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  void loadTopics() {
    subjects = List.from(box.get('subjects', defaultValue: []));
    topics = List.from(subjects[widget.subjectIndex]["topics"]);
    setState(() {});
  }

  void saveTopics() {
    subjects[widget.subjectIndex]["topics"] = topics;
    box.put('subjects', subjects);
  }

  void addTopic(String name) {
    topics.add({"name": name, "sessions": []});

    saveTopics();
    loadTopics();
  }

  void showAddTopicDialog() {
    String topicName = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Topic"),
          content: TextField(
            decoration: const InputDecoration(labelText: "Topic Name"),
            onChanged: (value) => topicName = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (topicName.isNotEmpty) {
                  addTopic(topicName);
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
      appBar: AppBar(title: const Text("Topics")),

      body: topics.isEmpty
          ? const Center(child: Text("No topics yet"))
          : ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final topic = topics[index];

                return ListTile(
                  title: Text(topic["name"]),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => StudyScreen()),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Topic"),
                          content: const Text("Are you sure?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                topics.removeAt(index);
                                saveTopics();
                                loadTopics();
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
        onPressed: showAddTopicDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
