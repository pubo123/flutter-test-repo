import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  String taskName = '';
  String priority = 'Medium'; // Default priority
  DateTime dueDate = DateTime.now();
  String notes = '';

  // Function to set priority automatically based on due date
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

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      updatePriority(); // Ensure priority is updated before saving

      // Return the created task to the homepage
      Navigator.pop(context, {
        'title': taskName,
        'priority': priority,
        'dueDate': DateFormat('yyyy-MM-dd').format(dueDate),
        'completed': false,
        'notes': notes,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Task'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Task name is required';
                  return null;
                },
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
                      updatePriority(); // Update priority when date changes
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              Text(
                'Priority: $priority',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
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
