import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task_model.dart';
import '../modules/persistence/shared_prefs_helper.dart';

// Абстрактный класс событий / Abstract event class
abstract class TaskEvent {}

// Событие загрузки задач из SharedPreferences
// Event to load tasks from SharedPreferences
class LoadTasksEvent extends TaskEvent {}

// Событие добавления задачи
// Event for adding a task
class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

// Событие переключения статуса выполнения задачи
// Event to toggle task completion status
class ToggleTaskEvent extends TaskEvent {
  final int index;
  ToggleTaskEvent(this.index);
}

// Абстрактное состояние / Abstract state class
abstract class TaskState {}

// Начальное состояние с списком задач / Initial state with task list
class TaskInitialState extends TaskState {
  final List<Task> tasks;
  TaskInitialState(this.tasks);
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitialState([])) {
    // При загрузке задач из SharedPreferences
    on<LoadTasksEvent>((event, emit) async {
      List<Task> tasks = await SharedPrefsHelper.loadTasks();
      emit(TaskInitialState(tasks));
    });

    // Добавление задачи
    on<AddTaskEvent>((event, emit) async {
      if (state is TaskInitialState) {
        final currentState = state as TaskInitialState;
        final updatedTasks = List<Task>.from(currentState.tasks)
          ..add(event.task);
        await SharedPrefsHelper.saveTasks(updatedTasks);
        emit(TaskInitialState(updatedTasks));
      }
    });

    // Переключение статуса выполнения задачи
    on<ToggleTaskEvent>((event, emit) async {
      if (state is TaskInitialState) {
        final currentState = state as TaskInitialState;
        final updatedTasks = List<Task>.from(currentState.tasks);
        final task = updatedTasks[event.index];
        task.isCompleted = !task.isCompleted;
        await SharedPrefsHelper.saveTasks(updatedTasks);
        emit(TaskInitialState(updatedTasks));
      }
    });
  }
}
