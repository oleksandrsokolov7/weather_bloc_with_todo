import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_with_todo/repositories/task_repository.dart';
import 'package:weather_bloc_with_todo/ui/task_Item.dart';
import '../blocs/task/task_bloc.dart';

import 'task_add_dialog.dart'; // Import the dialog for adding tasks

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late TaskBloc taskBloc;
  String selectedCategory = 'All'; // Category filtering
  bool showCompleted = true; // Status filtering

  @override
  void initState() {
    super.initState();
    final taskRepository = TaskRepository();
    taskBloc = TaskBloc(taskRepository);
    taskBloc.add(LoadTasksEvent()); // Load tasks when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (_) => taskBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task Manager'),
          actions: [
            // Filter by task completion status
            Switch(
              value: showCompleted,
              onChanged: (value) {
                setState(() {
                  showCompleted = value;
                });
              },
            ),
            // Filter by category (Dropdown menu)
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
              items: ['All', 'Work', 'Personal']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
            ),
          ],
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskInitialState) {
              var tasks = state.tasks;

              // Apply filtering
              tasks = tasks.where((task) {
                if (!showCompleted && task.isCompleted) return false;
                if (selectedCategory != 'All' &&
                    task.category != selectedCategory) {
                  return false;
                }
                return true;
              }).toList();

              if (tasks.isEmpty) {
                return Center(child: Text('No tasks available'));
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskItem(
                      task: task, index: index); // Display each task
                },
              );
            }
            return Center(
                child: CircularProgressIndicator()); // Show loading indicator
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                final taskBloc = BlocProvider.of<TaskBloc>(context);
                _showAddTaskDialog(
                    context, taskBloc); // Navigate to the add task dialog
              },
            );
          },
        ),
      ),
    );
  }

  // Method to show the Add Task dialog
  void _showAddTaskDialog(BuildContext context, TaskBloc taskBloc) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return TaskAddDialog(taskBloc: taskBloc); // Display the add task dialog
      },
    );
  }

  @override
  void dispose() {
    taskBloc.close(); // Close the BLoC when the widget is disposed
    super.dispose();
  }
}
