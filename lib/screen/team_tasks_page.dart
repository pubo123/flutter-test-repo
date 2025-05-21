import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamTasksPage extends StatefulWidget {
  final String teamId;
  final String teamName;

  const TeamTasksPage({required this.teamId, required this.teamName});

  @override
  _TeamTasksPageState createState() => _TeamTasksPageState();
}

class _TeamTasksPageState extends State<TeamTasksPage> {
  final _firestore = FirebaseFirestore.instance;

  Future<void> _uploadFile(BuildContext context, String taskId) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.bytes != null) {
      final file = result.files.single;
      final ref = FirebaseStorage.instance
          .ref()
          .child('team_tasks/${widget.teamId}/$taskId/${file.name}');
      await ref.putData(file.bytes!);
      final url = await ref.getDownloadURL();

      // Save file metadata under task
      await FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('files')
          .add({'name': file.name, 'url': url});
      
      // Send push notification (optional)
      await FirebaseMessaging.instance.sendMessage(
        to: '/topics/team_updates',
        data: {
        'title': '📎 File Uploaded',
        'body': '${file.name} uploaded in ${widget.teamName}',
        },
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("✅ File uploaded")));
    }
  }

  Future<void> _editTaskDialog(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final _formKey = GlobalKey<FormState>();
    String title = data['title'] ?? '';
    String assignee = data['assignee'] ?? '';
    DateTime dueDate = (data['dueDate'] as Timestamp).toDate();
    String notes = data['notes'] ?? '';
    String status = data['status'] ?? 'Not Started';

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Task"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (val) => title = val ?? '',
              ),
              TextFormField(
                initialValue: assignee,
                decoration: InputDecoration(labelText: 'Assignee'),
                onSaved: (val) => assignee = val ?? '',
              ),
              ListTile(
                title: Text('Due: ${DateFormat('yyyy-MM-dd').format(dueDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dueDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => dueDate = picked);
                  }
                },
              ),
              TextFormField(
                initialValue: notes,
                decoration: InputDecoration(labelText: 'Notes'),
                onSaved: (val) => notes = val ?? '',
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: InputDecoration(labelText: "Status"),
                items: ['Not Started', 'In Progress', 'Completed']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => status = val ?? 'Not Started',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState!.save();
              await doc.reference.update({
                'title': title,
                'assignee': assignee,
                'dueDate': Timestamp.fromDate(dueDate),
                'notes': notes,
                'status': status,
              });
              Navigator.pop(context);
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(DocumentSnapshot doc) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await doc.reference.delete();
    }
  }

  void _shareTask(Map<String, dynamic> task) {
    final msg = '📌 ${task['title']}\n👤 ${task['assignee']}\n📅 Due: ${DateFormat('yyyy-MM-dd').format((task['dueDate'] as Timestamp).toDate())}\n📝 ${task['notes']}';
    Share.share(msg);
  }

  @override
  Widget build(BuildContext context) {
    final taskStream = _firestore
        .collection('teams')
        .doc(widget.teamId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Team: ${widget.teamName}"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addTaskDialog(context),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: taskStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final tasks = snapshot.data!.docs;
          if (tasks.isEmpty) return Center(child: Text("No tasks found."));

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              final doc = tasks[i];
              final task = doc.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text(task['title']),
                  subtitle: Text("👤 ${task['assignee']} • 📅 ${DateFormat('yyyy-MM-dd').format((task['dueDate'] as Timestamp).toDate())}"),
                  children: [
                    FutureBuilder<QuerySnapshot>(
                      future: _firestore
                          .collection('teams')
                          .doc(widget.teamId)
                          .collection('tasks')
                          .doc(doc.id)
                          .collection('files')
                          .get(),
                      builder: (context, fileSnap) {
                        if (!fileSnap.hasData) return SizedBox();
                        final files = fileSnap.data!.docs;
                        if (files.isEmpty) return Text("No files attached.");

                        return Column(
                          children: files.map((f) {
                            final fileData = f.data() as Map<String, dynamic>;
                            return ListTile(
                              leading: Icon(Icons.file_present),
                              title: Text(fileData['name']),
                              trailing: IconButton(
                                icon: Icon(Icons.download),
                                onPressed: () async {
                                  final url = fileData['url'];
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("❌ Could not launch file")),
                                    );
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    ButtonBar(
                      children: [
                        IconButton(
                          icon: Icon(Icons.attach_file, color: Colors.indigo),
                          onPressed: () => _uploadFile(context, doc.id),
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.blue),
                          onPressed: () => _shareTask(task),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _editTaskDialog(doc),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(doc),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _addTaskDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String title = '';
    String assignee = '';
    String notes = '';
    DateTime dueDate = DateTime.now();
    String status = 'Not Started';

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Team Task"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (val) => title = val ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Assignee'),
                onSaved: (val) => assignee = val ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                onSaved: (val) => notes = val ?? '',
              ),
              ListTile(
                title: Text("Due: ${DateFormat('yyyy-MM-dd').format(dueDate)}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dueDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => dueDate = picked);
                },
              ),
              DropdownButtonFormField<String>(
                value: status,
                items: ['Not Started', 'In Progress', 'Completed']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => status = val ?? 'Not Started',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState!.save();
              await _firestore
                  .collection('teams')
                  .doc(widget.teamId)
                  .collection('tasks')
                  .add({
                'title': title,
                'assignee': assignee,
                'dueDate': Timestamp.fromDate(dueDate),
                'notes': notes,
                'status': status,
                'createdAt': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}
