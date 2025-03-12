import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  final List<Map<String, String>> tasks = [
    {'title': "Math Homework", 'dueDate': "2024-12-15"},
    {'title': "Team Meeting", 'dueDate': "2024-12-15"},
    {'title': "Science Project", 'dueDate': "2024-12-20"},
    {'title': "Report Submission", 'dueDate': "2024-12-18"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Tasks Calendar View",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: Icon(Icons.calendar_today, color: Colors.deepPurple),
                    title: Text(task['title']!),
                    subtitle: Text("Due Date: ${task['dueDate']}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
