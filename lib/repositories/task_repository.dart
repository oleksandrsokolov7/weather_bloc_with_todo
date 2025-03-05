import 'package:weather_bloc_with_todo/models/task_model.dart';
import 'package:weather_bloc_with_todo/modules/persistence/shared_prefs_helper.dart';

/// Repository for handling task data storage and retrieval.
class TaskRepository {
  /// Loads tasks from persistent storage.
  /// This method retrieves the list of tasks from SharedPreferences.
  Future<List<Task>> loadTasks() async {
    try {
      return await SharedPrefsHelper.loadTasks();
    } catch (e) {
      throw Exception('Failed to load tasks');
    }
  }

  /// Saves tasks to persistent storage.
  /// This method saves the list of tasks to SharedPreferences.
  Future<void> saveTasks(List<Task> tasks) async {
    try {
      await SharedPrefsHelper.saveTasks(tasks);
    } catch (e) {
      throw Exception('Failed to save tasks');
    }
  }
}
