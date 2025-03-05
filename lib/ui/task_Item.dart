import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task_model.dart';
import '../blocs/task/task_bloc.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final int index;

  const TaskItem({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // Unique key for dismissible widget using task title and index
      key: ValueKey('${task.title}_$index'),

      // Defines the swipe direction: horizontal
      direction: DismissDirection.horizontal,

      // Confirms the dismissal action based on the swipe direction
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // If swiped from left to right, mark the task as completed
          BlocProvider.of<TaskBloc>(context).add(MarkTaskCompletedEvent(index));
          return false; // Prevent the task from being dismissed
        } else if (direction == DismissDirection.endToStart) {
          // If swiped from right to left, delete the task
          return true;
        }
        return false;
      },

      // Handles the action after the task is dismissed
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          // If task is deleted, dispatch delete event and show snack bar
          BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(index));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${task.title} deleted")),
          );
        }
      },

      // Background for the swipe action when swiping from left to right (mark as completed)
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16.0),
        child: Icon(Icons.check, color: Colors.white),
      ),

      // Background for the swipe action when swiping from right to left (delete task)
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),

      // The actual content of the task item (list tile)
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            // Line-through for completed tasks
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            // Red color for important tasks
            color: task.priority == 'Important' ? Colors.red : Colors.black,
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
        // Display a check icon for completed tasks
        trailing:
            task.isCompleted ? Icon(Icons.done, color: Colors.green) : null,
      ),
    );
  }
}
