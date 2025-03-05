// Task model class to represent a task
class Task {
  final String title;
  final String description;
  final String category;
  final String priority; // 'important' or 'normal'
  bool isCompleted;

  // Constructor to create a Task instance
  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.isCompleted = false,
  });

  // Converts the task into a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  // Creates a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'] ?? 'normal',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  // Method to copy a Task with optional changes to its attributes
  Task copyWith({
    String? title,
    String? description,
    String? category,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
