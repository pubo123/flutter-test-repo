import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('tasks')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final now = DateTime.now();
          final tasks = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final dueDate = DateTime.parse(data['dueDate']);
            data['status'] = dueDate.isBefore(now)
                ? 'overdue'
                : dueDate.difference(now).inDays <= 2
                    ? 'upcoming'
                    : 'normal';
            return data;
          }).where((task) => task['status'] != 'normal').toList();

          if (tasks.isEmpty) {
            return Center(child: Text("No alerts! 🎉"));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    task['status'] == 'overdue'
                        ? Icons.warning_amber_rounded
                        : Icons.notifications_active,
                    color: task['status'] == 'overdue' ? Colors.red : Colors.orange,
                  ),
                  title: Text(task['title']),
                  subtitle: Text(
                    "${task['status'].toUpperCase()} • Due: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(task['dueDate']))}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
