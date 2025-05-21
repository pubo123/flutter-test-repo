import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskDetailsPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final Function onDelete;
  final Function(String, String) onUpdate;
  final String title;

  TaskDetailsPage({
    required this.task,
    required this.onDelete,
    required this.onUpdate,
    required this.title, required String docId,
  });

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late TextEditingController titleController;
  late TextEditingController notesController;
  bool isUpdating = false;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task['title']);
    notesController = TextEditingController(text: widget.task['notes']);
  }

  Future<void> updateTask() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docId = widget.task['id'];

    setState(() => isUpdating = true);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(docId)
        .update({
      'title': titleController.text,
      'notes': notesController.text,
    });

    widget.onUpdate(titleController.text, notesController.text);
    Navigator.pop(context);
  }

  Future<void> deleteTask() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docId = widget.task['id'];

    setState(() => isDeleting = true);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(docId)
        .delete();

    widget.onDelete();
    Navigator.pop(context);
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteTask();
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: confirmDelete,
          ),
        ],
      ),
      body: isUpdating || isDeleting
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: "Task Title"),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: "Notes"),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateTask,
                    child: Text("Save Changes"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  ),
                ],
              ),
            ),
    );
  }
}
