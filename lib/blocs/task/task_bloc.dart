import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/task_model.dart';
import '../../repositories/task_repository.dart';

/// Bloc for managing tasks with state management.
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitialState([])) {
    // Handling event to load tasks from repository
    on<LoadTasksEvent>((event, emit) async {
      try {
        List<Task> tasks = await repository.loadTasks();
        emit(TaskInitialState(tasks));
      } catch (e) {
        emit(TaskErrorState('Failed to load tasks'));
      }
    });

    // Handling event to add a new task
    on<AddTaskEvent>((event, emit) async {
      if (state is TaskInitialState) {
        final currentState = state as TaskInitialState;
        final updatedTasks = List<Task>.from(currentState.tasks)
          ..add(event.task);

        try {
          await repository.saveTasks(updatedTasks);
          emit(TaskInitialState(updatedTasks));
        } catch (e) {
          emit(TaskErrorState('Failed to save task'));
        }
      }
    });

    // Handling event to mark a task as completed
    on<MarkTaskCompletedEvent>((event, emit) async {
      if (state is TaskInitialState) {
        final currentState = state as TaskInitialState;
        final updatedTasks = List<Task>.from(currentState.tasks);
        updatedTasks[event.index] =
            updatedTasks[event.index].copyWith(isCompleted: true);

        try {
          await repository.saveTasks(updatedTasks);
          emit(TaskInitialState(updatedTasks));
        } catch (e) {
          emit(TaskErrorState('Failed to update task'));
        }
      }
    });

    // Handling event to delete a task
    on<DeleteTaskEvent>((event, emit) async {
      if (state is TaskInitialState) {
        final currentState = state as TaskInitialState;
        final updatedTasks = List<Task>.from(currentState.tasks)
          ..removeAt(event.index);

        try {
          await repository.saveTasks(updatedTasks);
          emit(TaskInitialState(updatedTasks));
        } catch (e) {
          emit(TaskErrorState('Failed to delete task'));
        }
      }
    });
  }
}

/// Abstract event class for task management
abstract class TaskEvent {}

/// Event to load tasks from the repository
class LoadTasksEvent extends TaskEvent {}

/// Event for adding a new task
class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

/// Event to mark a task as completed via swipe
class MarkTaskCompletedEvent extends TaskEvent {
  final int index;
  MarkTaskCompletedEvent(this.index);
}

/// Event for deleting a task
class DeleteTaskEvent extends TaskEvent {
  final int index;
  DeleteTaskEvent(this.index);
}

/// Abstract state class for task management
abstract class TaskState {}

/// Initial state containing a list of tasks
class TaskInitialState extends TaskState {
  final List<Task> tasks;
  TaskInitialState(List<Task> tasks) : tasks = List.unmodifiable(tasks);
}

/// State representing an error during task operations
class TaskErrorState extends TaskState {
  final String message;
  TaskErrorState(this.message);
}
