import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true; // Default value for notifications switch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Section Header
          Text("Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          SizedBox(height: 10),

          // Notifications Toggle
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: Text("Enable Notifications", style: TextStyle(fontSize: 16)),
              secondary: Icon(Icons.notifications, color: Colors.pinkAccent),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),

          // Section Header
          Text("General", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          SizedBox(height: 10),

          // Privacy & Security
          _buildSettingsOption(Icons.lock, "Privacy & Security", () {
            // Navigate to Privacy settings
          }),

          // Help & Support
          _buildSettingsOption(Icons.help, "Help & Support", () {
            // Navigate to Help page
          }),
        ],
      ),
    );
  }

  // Reusable ListTile for options
  Widget _buildSettingsOption(IconData icon, String title, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.pinkAccent),
        title: Text(title, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
