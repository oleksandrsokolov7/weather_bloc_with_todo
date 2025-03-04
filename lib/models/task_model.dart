// Модель задачи / Task model
// Содержит поля для названия, описания, категории и статуса выполнения
// Contains fields for title, description, category, and completion status

class Task {
  final String title;
  final String description;
  final String category;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
  });

  // Метод для преобразования задачи в Map (например, для сохранения в SharedPreferences)
  // Method to convert task to a Map (for saving in SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'isCompleted': isCompleted,
    };
  }

  // Метод для создания задачи из Map
  // Method to create a task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      category: map['category'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
