import 'package:remind/models/task_model.dart';

final List<Task> sampleTasks = [
  Task(
    id: '1',
    title: 'Complete Project Presentation',
    description: 'Prepare and finalize the project presentation for the team meeting',
    dueDate: DateTime.now().add(const Duration(days: 2)),
    points: 100,
    categoryId: '1',
  ),
  Task(
    id: '2',
    title: 'Daily Exercise',
    description: '30 minutes of cardio workout',
    dueDate: DateTime.now().add(const Duration(days: 1)),
    points: 50,
    categoryId: '3',
  ),
  Task(
    id: '3',
    title: 'Read a Book Chapter',
    description: 'Read one chapter of the current book',
    dueDate: DateTime.now().add(const Duration(days: 1)),
    points: 30,
    categoryId: '3',
  ),
]; 