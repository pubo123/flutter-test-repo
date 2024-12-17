import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "DoSmart",
    home: Home_Screen(),
    theme: ThemeData(primarySwatch: Colors.deepPurple),
  ));
}

class Home_Screen extends StatefulWidget {
  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  // List of tasks for Today and Upcoming sections
  List<Map<String, dynamic>> todayTasks = [
    {'title': "Math Homework", 'priority': "High", 'dueDate': "Dec 15", 'completed': false},
    {'title': "Team Meeting", 'priority': "Medium", 'dueDate': "Dec 15", 'completed': false},
  ];

  List<Map<String, dynamic>> upcomingTasks = [
    {'title': "Science Project", 'priority': "Low", 'dueDate': "Dec 20", 'completed': false},
    {'title': "Report Submission", 'priority': "High", 'dueDate': "Dec 18", 'completed': false},
  ];

  // Function to delete a task
  void deleteTask(List tasks, int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Function to mark a task as completed
  void toggleComplete(List tasks, int index) {
    setState(() {
      tasks[index]['completed'] = !tasks[index]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("DoSmart"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to profile page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: "Today"),
            TaskList(
              tasks: todayTasks,
              onDelete: (index) => deleteTask(todayTasks, index),
              onComplete: (index) => toggleComplete(todayTasks, index),
            ),
            SectionTitle(title: "Upcoming"),
            TaskList(
              tasks: upcomingTasks,
              onDelete: (index) => deleteTask(upcomingTasks, index),
              onComplete: (index) => toggleComplete(upcomingTasks, index),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add task creation functionality
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Teams"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
        onTap: (index) {
          // Handle navigation between sections
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final Function(int) onDelete;
  final Function(int) onComplete;

  TaskList({required this.tasks, required this.onDelete, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tasks.asMap().entries.map((entry) {
          int idx = entry.key;
          Map task = entry.value;

          return TaskCard(
            title: task['title'],
            priority: task['priority'],
            dueDate: task['dueDate'],
            completed: task['completed'],
            onDelete: () => onDelete(idx),
            onComplete: () => onComplete(idx),
          );
        }).toList(),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String priority;
  final String dueDate;
  final bool completed;
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  TaskCard({
    required this.title,
    required this.priority,
    required this.dueDate,
    required this.completed,
    required this.onDelete,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.all(10.0),
      width: 150.0,
      decoration: BoxDecoration(
        color: completed ? Colors.grey.shade300 : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5.0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              decoration: completed ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            "Priority: $priority",
            style: TextStyle(color: Colors.redAccent),
          ),
          Text("Due: $dueDate"),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onComplete,
                child: Icon(
                  completed ? Icons.check_circle : Icons.check_circle_outline,
                  color: completed ? Colors.green : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
