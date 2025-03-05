import 'package:flutter/material.dart';
import '../blocs/task/task_bloc.dart';
import '../models/task_model.dart';

class TaskAddDialog extends StatefulWidget {
  final TaskBloc taskBloc;

  const TaskAddDialog({super.key, required this.taskBloc});

  @override
  _TaskAddDialogState createState() => _TaskAddDialogState();
}

class _TaskAddDialogState extends State<TaskAddDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isImportant = false; // Whether the task is important or not
  bool isWorkCategory = true; // Task category: Work (true) or Personal (false)

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text('Add Task', style: TextStyle(fontWeight: FontWeight.bold)),
      content: StatefulBuilder(
        builder: (dialogContext, setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title input field
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                // Description input field
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 10),

                // Priority switch for "Important / Normal"
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
                          isImportant =
                              value; // Update priority when switch is toggled
                        });
                      },
                    ),
                    // Display the current priority
                    Text(isImportant ? 'Important' : 'Normal',
                        style: TextStyle(
                            color: isImportant ? Colors.red : Colors.black)),
                  ],
                ),

                // Category switch for "Work / Personal"
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
                          isWorkCategory =
                              value; // Update category when switch is toggled
                        });
                      },
                    ),
                    // Display the current category
                    Text(isWorkCategory ? 'Work' : 'Personal',
                        style: TextStyle(
                            color:
                                isWorkCategory ? Colors.blue : Colors.green)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        // Cancel button that closes the dialog
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        // Add button that creates a new task
        ElevatedButton(
          onPressed: () {
            final newTask = Task(
              title: titleController.text,
              description: descriptionController.text,
              category: isWorkCategory ? 'Work' : 'Personal',
              priority: isImportant ? 'Important' : 'Normal',
            );
            widget.taskBloc
                .add(AddTaskEvent(newTask)); // Add the new task to BLoC
            Navigator.pop(context); // Close the dialog after task is added
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Add'),
        ),
      ],
    );
  }
}
