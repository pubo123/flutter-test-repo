import 'package:flutter/material.dart';

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

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Save the task details (you can integrate this with a database)
      print("Task Saved: $taskName, $priority, $dueDate, $notes");
      Navigator.pop(context);
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
              DropdownButtonFormField<String>(
                value: priority,
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                    .toList(),
                onChanged: (value) => setState(() => priority = value!),
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Due Date: ${dueDate.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) setState(() => dueDate = pickedDate);
                },
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
