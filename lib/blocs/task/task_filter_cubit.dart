import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit responsible for managing task filter options.
/// Allows toggling the visibility of completed tasks and selecting a category.
class TaskFilterCubit extends Cubit<TaskFilterState> {
  TaskFilterCubit() : super(TaskFilterState());

  /// Toggles the visibility of completed tasks.
  void toggleShowCompleted() {
    emit(state.copyWith(showCompleted: !state.showCompleted));
  }

  /// Updates the selected task category.
  void changeCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
}

/// Represents the state of task filtering options.
class TaskFilterState {
  final bool showCompleted;
  final String selectedCategory;

  TaskFilterState({
    this.showCompleted = true,
    this.selectedCategory = 'All',
  });

  /// Returns a new instance of [TaskFilterState] with updated filter values.
  TaskFilterState copyWith({bool? showCompleted, String? selectedCategory}) {
    return TaskFilterState(
      showCompleted: showCompleted ?? this.showCompleted,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
