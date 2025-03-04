import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/task_bloc.dart';
import '../../models/task_model.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late TaskBloc taskBloc;
  String selectedCategory = 'All'; // Фильтрация по категориям
  bool showCompleted = true; // Фильтрация по статусу

  @override
  void initState() {
    super.initState();
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
          actions: [
            // Фильтр по статусу
            Switch(
              value: showCompleted,
              onChanged: (value) {
                setState(() {
                  showCompleted = value;
                });
              },
            ),
            // Фильтр по категориям (выпадающее меню)
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

              // Применяем фильтрацию
              tasks = tasks.where((task) {
                if (!showCompleted && task.isCompleted) return false;
                if (selectedCategory != 'All' &&
                    task.category != selectedCategory) return false;
                return true;
              }).toList();

              if (tasks.isEmpty) {
                return Center(child: Text('No tasks available'));
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: ValueKey('${task.title}_$index'),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        BlocProvider.of<TaskBloc>(context)
                            .add(MarkTaskCompletedEvent(index));
                        return false;
                      } else if (direction == DismissDirection.endToStart) {
                        return true;
                      }
                      return false;
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        BlocProvider.of<TaskBloc>(context)
                            .add(DeleteTaskEvent(index));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${task.title} deleted")),
                        );
                      }
                    },
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16.0),
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.priority == 'Important'
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '${task.description} - ${task.category}',
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: task.isCompleted
                          ? Icon(Icons.done, color: Colors.green)
                          : null,
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: Builder(
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

  void _showAddTaskDialog(BuildContext context, TaskBloc taskBloc) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    bool isImportant = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Add Task'),
          content: SingleChildScrollView(
            child: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Important'),
                    Switch(
                      value: isImportant,
                      onChanged: (value) {
                        setState(() {
                          isImportant = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
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
                  priority: isImportant ? 'Important' : 'Normal',
                );
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
