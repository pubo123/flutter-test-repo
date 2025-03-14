import 'package:first_project/screen/create_task_page.dart';
import 'package:first_project/screen/task_details_page.dart';
import 'package:first_project/screen/calendar_page.dart';
import 'package:first_project/screen/notification_page.dart';
import 'package:first_project/screen/team_page.dart';
import 'package:first_project/screen/more_options_page.dart';
import 'package:first_project/screen/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  int _currentIndex = 0;

  List<Map<String, dynamic>> todayTasks = [
    {'title': "Math Homework", 'priority': "High", 'dueDate': "2024-03-15", 'completed': false},
    {'title': "Team Meeting", 'priority': "Medium", 'dueDate': "2024-03-15", 'completed': false},
  ];

  List<Map<String, dynamic>> upcomingTasks = [
    {'title': "Science Project", 'priority': "Low", 'dueDate': "2024-03-20", 'completed': false},
    {'title': "Report Submission", 'priority': "High", 'dueDate': "2024-03-18", 'completed': false},
  ];

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomeScreenBody(todayTasks: todayTasks, upcomingTasks: upcomingTasks),
      CalendarPage(),
      NotificationsPage(),
      TeamsPage(),
      MoreOptionsPage(),
    ]);
  }

  // Function to add new tasks dynamically
  void addNewTask(Map<String, dynamic> newTask) {
    DateTime taskDueDate = DateTime.parse(newTask['dueDate']);
    DateTime today = DateTime.now();

    setState(() {
      if (taskDueDate.difference(today).inDays <= 2) {
        todayTasks.add(newTask);
      } else {
        upcomingTasks.add(newTask);
      }
      _pages[0] = HomeScreenBody(todayTasks: todayTasks, upcomingTasks: upcomingTasks);
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex], // Load the selected page dynamically
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTaskPage()),
          );

          if (newTask != null) {
            addNewTask(newTask);
          }
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Teams"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  final List<Map<String, dynamic>> todayTasks;
  final List<Map<String, dynamic>> upcomingTasks;

  HomeScreenBody({required this.todayTasks, required this.upcomingTasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: "Today"),
          TaskList(tasks: todayTasks),
          SectionTitle(title: "Upcoming"),
          TaskList(tasks: upcomingTasks),
        ],
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

  TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks.map((task) {
        return ListTile(
          title: Text(task['title']),
          subtitle: Text("Priority: ${task['priority']} • Due: ${task['dueDate']}"),
        );
      }).toList(),
    );
  }
}
