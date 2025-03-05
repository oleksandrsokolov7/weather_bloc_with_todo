import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/task_model.dart';

// Helper class for SharedPreferences operations
class SharedPrefsHelper {
  static const String tasksKey = 'tasks';

  // Method to save the list of tasks
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert the list of tasks to a JSON string
    List<String> tasksJson =
        tasks.map((task) => json.encode(task.toMap())).toList();
    await prefs.setStringList(tasksKey, tasksJson);
  }

  // Method to load the list of tasks
  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? tasksJson = prefs.getStringList(tasksKey);
    if (tasksJson != null) {
      return tasksJson.map((taskJson) {
        Map<String, dynamic> taskMap = json.decode(taskJson);
        return Task.fromMap(taskMap);
      }).toList();
    }
    return [];
  }
}
