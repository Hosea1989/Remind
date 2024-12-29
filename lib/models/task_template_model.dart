import 'package:uuid/uuid.dart';
import 'package:remind/models/task_model.dart';

class TaskTemplate {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final int points;

  const TaskTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.points,
  });

  Task toTask() {
    return Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      categoryId: categoryId,
      points: points,
      dueDate: DateTime.now().add(const Duration(days: 1)),
    );
  }

  static const List<TaskTemplate> defaultTemplates = [
    TaskTemplate(
      id: 'daily_exercise',
      title: 'Daily Exercise',
      description: 'Complete 30 minutes of physical activity',
      categoryId: 'health',
      points: 100,
    ),
    TaskTemplate(
      id: 'study_session',
      title: 'Study Session',
      description: 'Study for upcoming exam',
      categoryId: 'study',
      points: 150,
    ),
    TaskTemplate(
      id: 'work_report',
      title: 'Weekly Report',
      description: 'Prepare and submit weekly progress report',
      categoryId: 'work',
      points: 200,
    ),
  ];
} 