import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/task_bloc.dart';
import '../../models/task_model.dart';

// Страница списка задач / Task List Page
class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late TaskBloc taskBloc;

  @override
  void initState() {
    super.initState();
    // Инициализация TaskBloc и загрузка сохранённых задач
    // Initialize TaskBloc and load persisted tasks
    taskBloc = TaskBloc();
    taskBloc.add(LoadTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (_) => taskBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task Manager'),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskInitialState) {
              final tasks = state.tasks;
              if (tasks.isEmpty) {
                return Center(
                  child: Text('No tasks added yet'),
                );
              }
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        // Переключение состояния задачи
                        // Toggle task completion status
                        BlocProvider.of<TaskBloc>(context)
                            .add(ToggleTaskEvent(index));
                      },
                    ),
                    onLongPress: () {
                      // TODO: Реализовать удаление задачи
                      // TODO: Implement task deletion
                    },
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: Builder(
          // Используем Builder для получения корректного контекста, находящегося внутри BlocProvider
          // Use Builder to get a context inside the BlocProvider
          builder: (context) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                final taskBloc = BlocProvider.of<TaskBloc>(context);
                _showAddTaskDialog(context, taskBloc);
              },
            );
          },
        ),
      ),
    );
  }

  // Метод для отображения диалога добавления новой задачи
  // Method to display a dialog for adding a new task
  void _showAddTaskDialog(BuildContext context, TaskBloc taskBloc) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newTask = Task(
                  title: titleController.text,
                  description: descriptionController.text,
                  category: categoryController.text,
                );
                // Добавление новой задачи через BLoC
                // Add new task via BLoC
                taskBloc.add(AddTaskEvent(newTask));
                Navigator.pop(dialogContext);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    taskBloc.close();
    super.dispose();
  }
}
