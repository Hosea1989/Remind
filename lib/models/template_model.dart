import 'package:uuid/uuid.dart';
import 'package:remind/models/task_model.dart';

class TaskTemplate {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final int points;
  final Duration? defaultDuration;

  const TaskTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.points,
    this.defaultDuration,
  });

  Task toTask() {
    return Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      categoryId: categoryId,
      points: points,
      dueDate: defaultDuration != null
          ? DateTime.now().add(defaultDuration!)
          : DateTime.now().add(const Duration(days: 1)),
      isCompleted: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'points': points,
      'defaultDuration': defaultDuration?.inMinutes,
    };
  }

  factory TaskTemplate.fromMap(Map<String, dynamic> map) {
    return TaskTemplate(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      categoryId: map['categoryId'],
      points: map['points'],
      defaultDuration: map['defaultDuration'] != null
          ? Duration(minutes: map['defaultDuration'])
          : null,
    );
  }
} 