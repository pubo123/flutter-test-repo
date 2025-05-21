import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_project/screen/team_tasks_page.dart';

class TeamsPage extends StatelessWidget {
  final String currentUid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _createTestTeam(BuildContext context) async {
    try {
      final docRef = await FirebaseFirestore.instance.collection('teams').add({
        'name': 'Dev Test Team',
        'created_by': currentUid,
        'members': [currentUid],
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Test team created")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TeamTasksPage(teamId: docRef.id, teamName: 'Dev Test Team')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to create test team: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.developer_mode),
            onPressed: () => _createTestTeam(context), // 🔧 Dev-only button
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teams')
            .where('members', arrayContains: currentUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final teams = snapshot.data!.docs;

          if (teams.isEmpty) {
            return Center(child: Text("No teams found."));
          }

          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              final teamData = team.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(teamData['name'] ?? 'Unnamed Team'),
                subtitle: Text("Team ID: ${team.id}"),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TeamTasksPage(
                        teamId: team.id,
                        teamName: teamData['name'] ?? 'Unnamed Team',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
