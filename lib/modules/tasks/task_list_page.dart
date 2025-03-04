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
                  return Dismissible(
                    key: ValueKey('${task.title}_$index'),
                    // Позволяем свайп в обе стороны
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      // Если свайп вправо, только помечаем как выполненную, не удаляя элемент
                      if (direction == DismissDirection.startToEnd) {
                        // Отправляем событие для отметки задачи как выполненной
                        BlocProvider.of<TaskBloc>(context)
                            .add(MarkTaskCompletedEvent(index));
                        return false; // не удаляем элемент из списка
                      } else if (direction == DismissDirection.endToStart) {
                        // Если свайп влево, подтверждаем удаление
                        return true;
                      }
                      return false;
                    },
                    onDismissed: (direction) {
                      // Свайп влево: удаление задачи
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
                        ),
                      ),
                      subtitle: Text(
                        '${task.description} - Priority: ${task.priority}',
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

  // Метод для отображения диалога добавления новой задачи / Method to display a dialog for adding a new task
  void _showAddTaskDialog(BuildContext context, TaskBloc taskBloc) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final priorityController = TextEditingController();

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
                TextField(
                  controller: priorityController,
                  decoration:
                      InputDecoration(labelText: 'Priority (important/normal)'),
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
                  priority: priorityController.text.isNotEmpty
                      ? priorityController.text
                      : 'normal',
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
