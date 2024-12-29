import 'package:sqflite/sqflite.dart';
import 'package:remind/models/task_model.dart';
import 'package:remind/services/database_service.dart';

class TaskHistory {
  final String id;
  final String taskId;
  final String title;
  final String categoryId;
  final int points;
  final DateTime completedAt;

  const TaskHistory({
    required this.id,
    required this.taskId,
    required this.title,
    required this.categoryId,
    required this.points,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_id': taskId,
      'title': title,
      'category_id': categoryId,
      'points': points,
      'completed_at': completedAt.toIso8601String(),
    };
  }

  factory TaskHistory.fromMap(Map<String, dynamic> map) {
    return TaskHistory(
      id: map['id'],
      taskId: map['task_id'],
      title: map['title'],
      categoryId: map['category_id'],
      points: map['points'],
      completedAt: DateTime.parse(map['completed_at']),
    );
  }
}

class HistoryService {
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();

  final _db = DatabaseService();

  Future<void> recordCompletion(Task task) async {
    final db = await _db.database;
    final history = TaskHistory(
      id: const Uuid().v4(),
      taskId: task.id,
      title: task.title,
      categoryId: task.categoryId,
      points: task.points,
      completedAt: DateTime.now(),
    );

    await db.insert('task_history', history.toMap());
  }

  Future<List<TaskHistory>> getHistory({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
  }) async {
    final db = await _db.database;
    
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (startDate != null) {
      whereClause += 'completed_at >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'completed_at <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    if (categoryId != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'category_id = ?';
      whereArgs.add(categoryId);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'task_history',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'completed_at DESC',
    );

    return List.generate(maps.length, (i) => TaskHistory.fromMap(maps[i]));
  }

  Future<Map<String, int>> getPointsByCategory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final history = await getHistory(
      startDate: startDate,
      endDate: endDate,
    );

    final pointsByCategory = <String, int>{};
    for (final item in history) {
      pointsByCategory[item.categoryId] = 
          (pointsByCategory[item.categoryId] ?? 0) + item.points;
    }

    return pointsByCategory;
  }

  Future<List<MapEntry<DateTime, int>>> getDailyPoints({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final history = await getHistory(
      startDate: startDate,
      endDate: endDate,
    );

    final dailyPoints = <DateTime, int>{};
    for (final item in history) {
      final date = DateTime(
        item.completedAt.year,
        item.completedAt.month,
        item.completedAt.day,
      );
      dailyPoints[date] = (dailyPoints[date] ?? 0) + item.points;
    }

    return dailyPoints.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }
} 