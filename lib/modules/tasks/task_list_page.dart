import 'package:flutter/material.dart';
// Импорт модели задачи
// Import the Task model
import '../../models/task_model.dart';

// Страница списка задач / Task List Page
// Здесь в дальнейшем будет реализована логика отображения списка задач
// This page will later implement the task list display logic
class TaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: Center(
        child: Text(
          'Список задач будет здесь', // "Task list will be here"
          // Комментарии для понимания, что здесь будет отображаться список задач
          // A placeholder indicating that the task list will be displayed here
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Логика добавления новой задачи (пока что заглушка)
          // Placeholder for adding a new task logic
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
