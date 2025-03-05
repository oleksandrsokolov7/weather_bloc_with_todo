import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/task_model.dart';
import '../../modules/persistence/shared_prefs_helper.dart';

// Абстрактный класс событий / Abstract event class
abstract class TaskEvent {}

// Событие загрузки задач из SharedPreferences / Event to load tasks from SharedPreferences
class LoadTasksEvent extends TaskEvent {}

// Событие добавления задачи / Event for adding a task
class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

// Событие отметки задачи как выполненной (при свайпе) / Event to mark a task as completed via swipe
class MarkTaskCompletedEvent extends TaskEvent {
  final int index;
  MarkTaskCompletedEvent(this.index);
}

// Событие удаления задачи / Event for deleting a task
class DeleteTaskEvent extends TaskEvent {
  final int index;
  DeleteTaskEvent(this.index);
}

// Абстрактное состояние / Abstract state class
abstract class TaskState {}

// Начальное состояние с задачами / Initial state with task list
class TaskInitialState extends TaskState {
  final List<Task> tasks;
  TaskInitialState(this.tasks);
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitialState([])) {
    // Обработка события загрузки задач
    on<LoadTasksEvent>((event, emit) async {
      List<Task> tasks = await SharedPrefsHelper.loadTasks();
      emit(TaskInitialState(tasks));
    });

    // Обработка события добавления задачи
    on<AddTaskEvent>((event, emit) async {
      if (state is TaskInitialState) {
        final currentState = state as TaskInitialState;
        final updatedTasks = List<Task>.from(currentState.tasks)
          ..add(event.task);
        await SharedPrefsHelper.saveTasks(updatedTasks);
        emit(TaskInitialState(updatedTasks));
      }
    });

    // Обработка события отметки задачи как выполненной
    on<MarkTaskCompletedEvent>((event, emit) async {
      if (state is TaskInitialState) {
        final currentState = state as TaskInitialState;
        final updatedTasks = List<Task>.from(currentState.tasks);
        updatedTasks[event.index].isCompleted = true;
        await SharedPrefsHelper.saveTasks(updatedTasks);
        emit(TaskInitialState(updatedTasks));
      }
    });

    // Обработка события удаления задачи
    on<DeleteTaskEvent>((event, emit) async {
      if (state is TaskInitialState) {
        final currentState = state as TaskInitialState;
        final updatedTasks = List<Task>.from(currentState.tasks);
        updatedTasks.removeAt(event.index);
        await SharedPrefsHelper.saveTasks(updatedTasks);
        emit(TaskInitialState(updatedTasks));
      }
    });
  }
}
