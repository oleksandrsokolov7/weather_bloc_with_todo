import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../models/task_model.dart';

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

    bool isImportant = false;
    bool isWorkCategory = true; // Work (true) или Personal (false)

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title:
              Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            // Используем StatefulBuilder для обновления UI
            builder: (dialogContext, setState) {
              return SingleChildScrollView(
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
                    SizedBox(height: 10),

                    // Переключатель "Important / Normal"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Priority:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Switch(
                          value: isImportant,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              isImportant = value;
                            });
                          },
                        ),
                        Text(isImportant ? 'Important' : 'Normal',
                            style: TextStyle(
                                color:
                                    isImportant ? Colors.red : Colors.black)),
                      ],
                    ),

                    // Переключатель "Work / Personal"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Category:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Switch(
                          value: isWorkCategory,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              isWorkCategory = value;
                            });
                          },
                        ),
                        Text(isWorkCategory ? 'Work' : 'Personal',
                            style: TextStyle(
                                color: isWorkCategory
                                    ? Colors.blue
                                    : Colors.green)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final newTask = Task(
                  title: titleController.text,
                  description: descriptionController.text,
                  category: isWorkCategory ? 'Work' : 'Personal',
                  priority: isImportant ? 'Important' : 'Normal',
                );
                taskBloc.add(AddTaskEvent(newTask));
                Navigator.pop(dialogContext);
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
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
