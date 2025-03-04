import 'package:flutter_bloc/flutter_bloc.dart';

class TaskFilterCubit extends Cubit<TaskFilterState> {
  TaskFilterCubit() : super(TaskFilterState());

  void toggleShowCompleted() {
    emit(state.copyWith(showCompleted: !state.showCompleted));
  }

  void changeCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
}

class TaskFilterState {
  final bool showCompleted;
  final String selectedCategory;

  TaskFilterState({
    this.showCompleted = true,
    this.selectedCategory = 'All',
  });

  TaskFilterState copyWith({bool? showCompleted, String? selectedCategory}) {
    return TaskFilterState(
      showCompleted: showCompleted ?? this.showCompleted,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
