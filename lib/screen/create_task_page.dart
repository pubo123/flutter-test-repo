import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String taskName = '';
  String priority = 'Medium';
  DateTime dueDate = DateTime.now();
  String notes = '';
  bool isSaving = false;

  void updatePriority() {
    final today = DateTime.now();
    final difference = dueDate.difference(today).inDays;
    setState(() {
      if (difference <= 2) {
        priority = "High";
      } else if (difference <= 5) {
        priority = "Medium";
      } else {
        priority = "Low";
      }
    });
  }

  Future<void> saveTaskToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      setState(() => isSaving = true);
      final taskData = {
        'title': taskName,
        'priority': priority,
        'dueDate': dueDate.toIso8601String(),
        'notes': notes,
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .add(taskData);

      Navigator.pop(context, true);
    } catch (e) {
      print("❌ Error saving task: $e");
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      updatePriority();
      saveTaskToFirestore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Task'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isSaving
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Task Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Task name is required' : null,
                      onSaved: (value) => taskName = value!,
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text('Due Date: ${DateFormat('yyyy-MM-dd').format(dueDate)}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dueDate = pickedDate;
                            updatePriority();
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Priority: $priority',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Notes'),
                      maxLines: 3,
                      onSaved: (value) => notes = value!,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveTask,
                      child: Text('Save Task'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
