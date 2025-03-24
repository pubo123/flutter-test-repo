import 'package:first_project/screen/create_task_page.dart';
import 'package:first_project/screen/task_details_page.dart';
import 'package:first_project/screen/calendar_page.dart';
import 'package:first_project/screen/notification_page.dart';
import 'package:first_project/screen/team_page.dart';
import 'package:first_project/screen/more_options_page.dart';
import 'package:first_project/screen/profile_page.dart';
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
  int _currentIndex = 0;

  List<Map<String, dynamic>> todayTasks = [
    {'title': "Math Homework", 'priority': "High", 'dueDate': "2025-03-19", 'notes': "Complete all exercises.", 'completed': false},
    {'title': "Team Meeting", 'priority': "High", 'dueDate': "2025-03-19", 'notes': "Discuss project milestones.", 'completed': false},
  ];

  List<Map<String, dynamic>> upcomingTasks = [
    {'title': "Science Project", 'priority': "Low", 'dueDate': "2025-04-13", 'notes': "Prepare presentation slides.", 'completed': false},
    {'title': "Report Submission", 'priority': "High", 'dueDate': "2025-04-14", 'notes': "Submit before deadline.", 'completed': false},
  ];

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomeScreenBody(todayTasks: todayTasks, upcomingTasks: upcomingTasks, onDeleteTask: deleteTask, onUpdateTask: updateTask),
      CalendarPage(),
      NotificationsPage(),
      TeamsPage(),
      MoreOptionsPage(),
    ]);
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
      refreshHomeScreen();
    });
  }

  void deleteTask(String taskTitle) {
    setState(() {
      todayTasks.removeWhere((task) => task['title'] == taskTitle);
      upcomingTasks.removeWhere((task) => task['title'] == taskTitle);
      refreshHomeScreen();
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

    // Ensure UI refreshes
    _pages[0] = HomeScreenBody(
      todayTasks: todayTasks, 
      upcomingTasks: upcomingTasks, 
      onDeleteTask: deleteTask, 
      onUpdateTask: updateTask
    );
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
            onPressed: () {},
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
  
  void refreshHomeScreen() {}
}

class HomeScreenBody extends StatelessWidget {
  final List<Map<String, dynamic>> todayTasks;
  final List<Map<String, dynamic>> upcomingTasks;
  final Function(String) onDeleteTask;
  final Function(String, String, String) onUpdateTask;

  HomeScreenBody({required this.todayTasks, required this.upcomingTasks, required this.onDeleteTask, required this.onUpdateTask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: "Today"),
          TaskList(tasks: todayTasks, onDelete: onDeleteTask, onUpdate: onUpdateTask),
          SectionTitle(title: "Upcoming"),
          TaskList(tasks: upcomingTasks, onDelete: onDeleteTask, onUpdate: onUpdateTask),
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
  final Function(String) onDelete;
  final Function(String, String, String) onUpdate;

  TaskList({required this.tasks, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks.map((task) => GestureDetector(
        onTap: () async {
          final updatedTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsPage(
                task: task,
                onDelete: () {
                  onDelete(task['title']);
                  Navigator.pop(context, 'deleted'); // Ensure we return 'deleted' if task is removed
                },
                onUpdate: (newTitle, newNotes) {
                  onUpdate(task['title'], newTitle, newNotes);
                },
              ),
            ),
          );

          if (updatedTask == 'deleted') {
            onDelete(task['title']); // Ensure task is removed from the UI
          }
        },
        child: Card(
          child: ListTile(
            title: Text(task['title']),
            subtitle: Text("Priority: ${task['priority']} • Due: ${task['dueDate']}"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
        )).toList(),
    );
  }
}
