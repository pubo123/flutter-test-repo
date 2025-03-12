import 'package:flutter/material.dart';

class TeamsPage extends StatelessWidget {
  final List<Map<String, dynamic>> teamTasks = [
    {'title': "Design Wireframe", 'assignee': "John", 'status': "In Progress"},
    {'title': "Project Presentation", 'assignee': "Emma", 'status': "Not Started"},
    {'title': "Code Review", 'assignee': "Mike", 'status': "Completed"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
        backgroundColor: Colors.deepPurple,
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
              subtitle: Text("Assigned to: ${task['assignee']}"),
              trailing: Text(
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
            ),
          );
        },
      ),
    );
  }
}
