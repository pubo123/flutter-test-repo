import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/3.jpg'),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 20),
            Text("Lee Zhi Jia", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("puboleengu@gmail.com", style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.deepPurple),
              title: Text("Settings"),
              onTap: () {
                // Navigate to Settings Page (to be added later)
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout"),
              onTap: () {
                // Handle Logout Functionality
                Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
              },
            ),
          ],
        ),
      ),
    );
  }
}
