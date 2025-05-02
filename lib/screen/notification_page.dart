import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {'message': "Task 'Math Homework' is overdue!", 'dueDate': "2025-04-18"},
    {'message': "Upcoming deadline for 'Team Meeting'.", 'dueDate': "2025-04-18"},
    {'message': "Task 'Science Project' is due soon!", 'dueDate': "2025-05-12"},
    {'message': "Task 'Report Submission' is due soon!", 'dueDate': "2025-05-14"},
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
          DateTime dueDate = DateFormat('yyyy-MM-dd').parse(notification['dueDate']!);
          String formattedDate = DateFormat('MMMM dd, yyyy').format(dueDate);

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.notifications_active, color: Colors.redAccent),
              title: Text(
                notification['message']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Due Date: $formattedDate",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          );
        },
      ),
    );
  }
}
