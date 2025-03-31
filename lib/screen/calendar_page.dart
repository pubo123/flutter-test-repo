import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatelessWidget {
  final List<Map<String, String>> tasks = [
    {'title': "Math Homework", 'dueDate': "2025-03-19"},
    {'title': "Team Meeting", 'dueDate': "2025-03-28"},
    {'title': "Science Project", 'dueDate': "2025-04-13"},
    {'title': "Report Submission", 'dueDate': "2025-04-14"},
  ];

  @override
  Widget build(BuildContext context) {
    // Sorting tasks by due date
    tasks.sort((a, b) {
      DateTime dateA = DateFormat('yyyy-MM-dd').parse(a['dueDate']!);
      DateTime dateB = DateFormat('yyyy-MM-dd').parse(b['dueDate']!);
      return dateA.compareTo(dateB);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "📆 Tasks Calendar View",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                DateTime dueDate = DateFormat('yyyy-MM-dd').parse(task['dueDate']!);
                String formattedDate = DateFormat('MMMM dd, yyyy').format(dueDate);

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.event, color: Colors.white),
                    ),
                    title: Text(
                      task['title']!,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to add new task
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
