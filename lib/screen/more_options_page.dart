import 'package:flutter/material.dart';

class MoreOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More Options"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.feedback, color: Colors.blueAccent),
            title: Text("Feedback"),
            subtitle: Text("Share your feedback with us."),
            onTap: () {
              // Navigate to Feedback Page (to be created)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.palette, color: Colors.orangeAccent),
            title: Text("Themes"),
            subtitle: Text("Change the app theme."),
            onTap: () {
              // Navigate to Themes Page (to be created)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThemesPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.teal),
            title: Text("About"),
            subtitle: Text("Learn more about this application."),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "DoSmart Task Manager",
                applicationVersion: "1.0.0",
                applicationIcon: Icon(Icons.task, color: Colors.deepPurple, size: 50),
                children: [
                  Text("This application helps you manage your tasks efficiently."),
                  Text("Developed by: [NSLEE]"),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Placeholder for Feedback Page
class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          "Feedback Form Coming Soon...",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// Placeholder for Themes Page
class ThemesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Themes"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          "Themes Feature Coming Soon...",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
