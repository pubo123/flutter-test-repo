import 'package:flutter/material.dart';

class TaskSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> tasks;

  TaskSearchDelegate(this.tasks);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ""; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> filteredTasks = tasks.where((task) {
      return task['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredTasks[index]['title']),
          subtitle: Text("Due: ${filteredTasks[index]['dueDate']}"),
          onTap: () {
            close(context, filteredTasks[index]); // Close and return result
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> suggestedTasks = tasks.where((task) {
      return task['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestedTasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestedTasks[index]['title']),
          subtitle: Text("Due: ${suggestedTasks[index]['dueDate']}"),
          onTap: () {
            query = suggestedTasks[index]['title']; // Set query text
            showResults(context); // Show full results
          },
        );
      },
    );
  }
}
