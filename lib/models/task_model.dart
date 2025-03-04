// Модель задачи / Task model
// Добавлено поле priority для определения важности задачи
class Task {
  final String title;
  final String description;
  final String category;
  final String priority; // 'important' или 'normal'
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.isCompleted = false,
  });

  // Преобразование задачи в Map для сохранения
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  // Создание задачи из Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'] ?? 'normal',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
