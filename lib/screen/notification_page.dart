import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {'message': "Task 'Math Homework' is overdue!", 'date': "2024-03-31"},
    {'message': "Upcoming deadline for 'Team Meeting'.", 'date': "2024-04-02"},
    {'message': "Task 'Report Submission' is due soon!", 'date': "2024-04-03"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.redAccent),
              title: Text(notification['message']!),
              subtitle: Text("Date: ${notification['date']}"),
            ),
          );
        },
      ),
    );
  }
}
