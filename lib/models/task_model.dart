class Task {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final int points;
  final DateTime dueDate;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.points,
    required this.dueDate,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    int? points,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      points: points ?? this.points,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'points': points,
      'categoryId': categoryId,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
} 