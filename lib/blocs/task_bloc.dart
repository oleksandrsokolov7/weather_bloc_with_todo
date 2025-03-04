// BLoC для управления состоянием задач / BLoC for task state management
// Здесь будет реализована логика управления списком задач, добавления, удаления и фильтрации
// This file will implement the logic for managing the task list, adding, deleting, and filtering tasks

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task_model.dart';

// Пример события для BLoC / Example event for BLoC
abstract class TaskEvent {}

// Событие добавления задачи / Event for adding a task
class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

// Другие события: удаление, обновление статуса и т.д.
// Other events: delete, update status, etc.

// Пример состояния для BLoC / Example state for BLoC
abstract class TaskState {}

// Начальное состояние с пустым списком задач / Initial state with an empty task list
class TaskInitialState extends TaskState {
  final List<Task> tasks;
  TaskInitialState(this.tasks);
}

// Пример реализации BLoC / Example implementation of BLoC
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitialState([])) {
    on<AddTaskEvent>((event, emit) {
      // Добавление задачи в список / Adding a task to the list
      final currentState = state;
      if (currentState is TaskInitialState) {
        final updatedTasks = List<Task>.from(currentState.tasks)
          ..add(event.task);
        emit(TaskInitialState(updatedTasks));
      }
    });
  }
}
