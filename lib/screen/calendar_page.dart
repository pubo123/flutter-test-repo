import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📆 Calendar View"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('tasks')
            .orderBy('dueDate')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final tasks = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

          final Map<String, List<Map<String, dynamic>>> groupedTasks = {};
          for (var task in tasks) {
            final date = DateFormat('yyyy-MM-dd').format(DateTime.parse(task['dueDate']));
            groupedTasks.putIfAbsent(date, () => []).add(task);
          }

          final sortedDates = groupedTasks.keys.toList()
            ..sort((a, b) => a.compareTo(b));

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final dateTasks = groupedTasks[date]!;

              return ExpansionTile(
                title: Text(
                  DateFormat('MMMM dd, yyyy').format(DateTime.parse(date)),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: dateTasks.map((task) {
                  return ListTile(
                    leading: Icon(Icons.event_note, color: Colors.deepPurple),
                    title: Text(task['title']),
                    subtitle: Text("Priority: ${task['priority']}"),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
