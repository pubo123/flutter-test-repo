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

// Feedback Page with input field, star rating, and submit button
class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 0; // Default rating

  void _submitFeedback() {
    if (_feedbackController.text.isNotEmpty || _rating > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thank you for your feedback! ⭐$_rating")),
      );
      _feedbackController.clear();
      setState(() {
        _rating = 0; // Reset rating
      });
    }
  }

  Widget _buildStar(int starIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _rating = starIndex;
        });
      },
      child: Icon(
        _rating >= starIndex ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("We value your feedback!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                hintText: "Type your feedback here...",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),

            Text("Rate the app:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => _buildStar(index + 1)),
            ),

            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: Text("Submit", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Themes Page with Light and Dark Mode selection
class ThemesPage extends StatefulWidget {
  @override
  _ThemesPageState createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  String _selectedTheme = "Light"; // Default theme

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Themes"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.light_mode, color: Colors.amber),
            title: Text("Light Theme"),
            trailing: Radio(
              value: "Light",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value.toString();
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode, color: Colors.black),
            title: Text("Dark Theme"),
            trailing: Radio(
              value: "Dark",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value.toString();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
