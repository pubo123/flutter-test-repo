import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:share_plus/share_plus.dart';

class TeamsPage extends StatelessWidget {
  final List<Map<String, dynamic>> teamTasks = [
    {'title': "Design Wireframe", 'assignee': "John", 'status': "In Progress", 'canEdit': false},
    {'title': "Project Presentation", 'assignee': "Emma", 'status': "Not Started", 'canEdit': false},
    {'title': "Code Review", 'assignee': "Mike", 'status': "Completed", 'canEdit': false},
  ];

  void _shareTask(BuildContext context, Map<String, dynamic> task) {
    final String taskDetails = "\ud83d\udccc Task: ${task['title']}\n\ud83d\udc64 Assigned to: ${task['assignee']}\n\ud83d\udcc5 Status: ${task['status']}";
    Share.share(taskDetails);
  }

  Future<void> _attachFile(BuildContext context, String taskTitle) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 5000000) { // 5MB limit
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File too large! Max 5MB allowed.")),
        );
        return;
      }

      Reference storageRef = FirebaseStorage.instance.ref().child('tasks/$taskTitle/${file.name}');
      await storageRef.putData(file.bytes!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File uploaded successfully!")),
      );

      // Send notification
      FirebaseMessaging.instance.subscribeToTopic('tasks');
      FirebaseMessaging.instance.sendMessage(
        to: '/topics/tasks',
        data: {'title': 'New File Attached', 'body': 'A new file was uploaded to $taskTitle.'},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share("\ud83d\udccb Check out our team tasks in DoSmart Task Manager!");
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: teamTasks.length,
        itemBuilder: (context, index) {
          final task = teamTasks[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.group, color: Colors.blueAccent),
              title: Text(task['title']!),
              subtitle: Text("\ud83d\udc64 Assigned to: ${task['assignee']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task['status']!,
                    style: TextStyle(
                      color: task['status'] == "Completed"
                          ? Colors.green
                          : task['status'] == "In Progress"
                              ? Colors.orange
                              : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.deepPurple),
                    onPressed: () => _attachFile(context, task['title']),
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.blue),
                    onPressed: () => _shareTask(context, task),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Only managers can add tasks!")),
          );
        },
      ),
    );
  }
}
