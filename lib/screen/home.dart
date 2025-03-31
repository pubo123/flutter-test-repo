import 'package:flutter/material.dart';
import 'package:first_project/screen/create_task_page.dart';
import 'package:first_project/screen/task_details_page.dart';
import 'package:first_project/screen/calendar_page.dart';
import 'package:first_project/screen/notification_page.dart';
import 'package:first_project/screen/team_page.dart';
import 'package:first_project/screen/more_options_page.dart';
import 'package:first_project/screen/profile_page.dart';

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
  String _searchQuery = "";

  List<Map<String, dynamic>> todayTasks = [
    {'title': "Math Homework", 'priority': "High", 'dueDate': "2025-03-19", 'notes': "Complete all exercises.", 'completed': false},
    {'title': "Team Meeting", 'priority': "High", 'dueDate': "2025-03-28", 'notes': "Discuss project milestones.", 'completed': false},
  ];

  List<Map<String, dynamic>> upcomingTasks = [
    {'title': "Science Project", 'priority': "Low", 'dueDate': "2025-04-13", 'notes': "Prepare presentation slides.", 'completed': false},
    {'title': "Report Submission", 'priority': "High", 'dueDate': "2025-04-14", 'notes': "Submit before deadline.", 'completed': false},
  ];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      HomeScreenBody(
        todayTasks: todayTasks,
        upcomingTasks: upcomingTasks,
        onDeleteTask: deleteTask,
        onUpdateTask: updateTask,
        searchQuery: _searchQuery,
      ),
      CalendarPage(),
      NotificationsPage(),
      TeamsPage(),
      MoreOptionsPage(),
    ];
  }

  void addNewTask(Map<String, dynamic> newTask) {
    DateTime taskDueDate = DateTime.parse(newTask['dueDate']);
    DateTime today = DateTime.now();

    setState(() {
      if (taskDueDate.difference(today).inDays <= 2) {
        todayTasks.add(newTask);
      } else {
        upcomingTasks.add(newTask);
      }
      _initializePages(); // Refresh home screen
    });
  }

  void deleteTask(String taskTitle) {
    setState(() {
      todayTasks.removeWhere((task) => task['title'] == taskTitle);
      upcomingTasks.removeWhere((task) => task['title'] == taskTitle);
      _initializePages();
    });
  }

  void updateTask(String oldTitle, String newTitle, String newNotes) {
    setState(() {
      bool found = false;
      for (var task in todayTasks) {
        if (task['title'] == oldTitle) {
          task['title'] = newTitle;
          task['notes'] = newNotes;
          found = true;
          break;
        }
      }

      if (!found) {
        for (var task in upcomingTasks) {
          if (task['title'] == oldTitle) {
            task['title'] = newTitle;
            task['notes'] = newNotes;
            break;
          }
        }
      }
      _initializePages();
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
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(todayTasks + upcomingTasks),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
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

TaskSearchDelegate(List<Map<String, dynamic>> list) {
}

class HomeScreenBody extends StatelessWidget {
  final List<Map<String, dynamic>> todayTasks;
  final List<Map<String, dynamic>> upcomingTasks;
  final Function(String) onDeleteTask;
  final Function(String, String, String) onUpdateTask;
  final String searchQuery;

  HomeScreenBody({
    required this.todayTasks,
    required this.upcomingTasks,
    required this.onDeleteTask,
    required this.onUpdateTask,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Text("Today", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...todayTasks.map((task) => TaskTile(task, onDeleteTask, onUpdateTask)),
        SizedBox(height: 20),
        Text("Upcoming", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...upcomingTasks.map((task) => TaskTile(task, onDeleteTask, onUpdateTask)),
      ],
    );
  }
}

class TaskTile extends StatelessWidget {
  final Map<String, dynamic> task;
  final Function(String) onDeleteTask;
  final Function(String, String, String) onUpdateTask;

  TaskTile(this.task, this.onDeleteTask, this.onUpdateTask);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task['title']),
      subtitle: Text("Priority: ${task['priority']} • Due: ${task['dueDate']}"),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          onDeleteTask(task['title']);
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsPage(
              task: task,
              onDelete: () => onDeleteTask(task['title']),
              onUpdate: (newTitle, newNotes) => onUpdateTask(task['title'], newTitle, newNotes),
              title: task['title'],
            ),
          ),
        );
      },
    );
  }
}
