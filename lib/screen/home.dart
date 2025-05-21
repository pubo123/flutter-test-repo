import 'package:flutter/material.dart';
import 'package:first_project/screen/create_task_page.dart';
import 'package:first_project/screen/task_details_page.dart';
import 'package:first_project/screen/calendar_page.dart';
import 'package:first_project/screen/notification_page.dart';
import 'package:first_project/screen/team_page.dart';
import 'package:first_project/screen/more_options_page.dart';
import 'package:first_project/screen/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Home_Screen extends StatefulWidget {
  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  int _currentIndex = 0;
  String _searchQuery = "";

  final _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final _pages = [
      TaskListView(uid: _uid, searchQuery: _searchQuery),
      CalendarPage(),
      NotificationsPage(),
      TeamsPage(),
      MoreOptionsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("DoSmart"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final tasksSnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(_uid)
                  .collection('tasks')
                  .get();
              final taskList = tasksSnapshot.docs.map((doc) => doc.data()).toList();
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(taskList),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateTaskPage()),
          );
          if (result != null && result is bool && result == true) {
            setState(() {}); // Refresh list after task creation
          }
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Teams"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  final String uid;
  final String searchQuery;

  TaskListView({required this.uid, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .orderBy('dueDate')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final tasks = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).where((task) =>
            task['title'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

        final today = DateTime.now();
        final todayTasks = tasks.where((task) =>
            DateFormat('yyyy-MM-dd').parse(task['dueDate']).difference(today).inDays <= 1).toList();
        final upcomingTasks = tasks.where((task) =>
            DateFormat('yyyy-MM-dd').parse(task['dueDate']).difference(today).inDays > 1).toList();

        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text("Today", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...todayTasks.map((task) => TaskTile(task: task, uid: uid)),
            SizedBox(height: 20),
            Text("Upcoming", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...upcomingTasks.map((task) => TaskTile(task: task, uid: uid)),
          ],
        );
      },
    );
  }
}

class TaskTile extends StatelessWidget {
  final Map<String, dynamic> task;
  final String uid;

  TaskTile({required this.task, required this.uid});

  void _toggleCompletion(bool? value) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task['id'])
        .update({'completed': value});
  }

  void _deleteTask(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task['id'])
        .delete();
  }

  void _updateTask(BuildContext context, String newTitle, String newNotes) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task['id'])
        .update({
          'title': newTitle,
          'notes': newNotes,
        });
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = task['completed'] == true;

    return ListTile(
      leading: Checkbox(
        value: isCompleted,
        onChanged: _toggleCompletion,
        activeColor: Colors.deepPurple,
      ),
      title: Text(
        task['title'],
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text("Priority: ${task['priority']} • Due: ${task['dueDate']}"),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () => _deleteTask(context),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailsPage(
              task: task,
              title: task['title'],
              onDelete: () => _deleteTask(context),
              onUpdate: (newTitle, newNotes) =>
                  _updateTask(context, newTitle, newNotes),
              docId: '',
            ),
          ),
        );
      },
    );
  }
}

class TaskSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> allTasks;

  TaskSearchDelegate(this.allTasks);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allTasks.where((task) =>
        task['title'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) => ListTile(
        title: Text(results[index]['title']),
        subtitle: Text("Due: ${results[index]['dueDate']}"),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = allTasks.where((task) =>
        task['title'].toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, index) => ListTile(
        title: Text(suggestions[index]['title']),
        onTap: () {
          query = suggestions[index]['title'];
          showResults(context);
        },
      ),
    );
  }
}
