import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:remind/models/task_model.dart';
import 'package:remind/services/database_service.dart';
import 'package:remind/services/history_service.dart';

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  final _db = DatabaseService();
  final _historyService = HistoryService();

  Future<String> exportData() async {
    // Get all data
    final tasks = await _db.getTasks();
    final history = await _historyService.getHistory();
    final stats = await _db.getStatisticsForRange(
      DateTime(2020),
      DateTime.now(),
    );

    // Create export data structure
    final exportData = {
      'version': '1.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'tasks': tasks.map((task) => {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate.toIso8601String(),
        'points': task.points,
        'categoryId': task.categoryId,
        'isCompleted': task.isCompleted,
      }).toList(),
      'history': history.map((item) => {
        'id': item.id,
        'taskId': item.taskId,
        'title': item.title,
        'categoryId': item.categoryId,
        'points': item.points,
        'completedAt': item.completedAt.toIso8601String(),
      }).toList(),
      'statistics': stats,
    };

    return jsonEncode(exportData);
  }

  Future<void> exportToFile() async {
    final data = await exportData();
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/remind_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(data);
    await Share.shareXFiles([XFile(file.path)], subject: 'Remind App Backup');
  }

  Future<bool> importData(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      
      // Validate version
      final version = data['version'] as String;
      if (version != '1.0.0') {
        throw Exception('Unsupported backup version');
      }

      // Begin transaction
      final db = await _db.database;
      await db.transaction((txn) async {
        // Clear existing data
        await txn.delete('tasks');
        await txn.delete('task_history');
        await txn.delete('statistics');

        // Import tasks
        for (final taskData in data['tasks'] as List) {
          final task = Task(
            id: taskData['id'],
            title: taskData['title'],
            description: taskData['description'],
            dueDate: DateTime.parse(taskData['dueDate']),
            points: taskData['points'],
            categoryId: taskData['categoryId'],
            isCompleted: taskData['isCompleted'],
          );
          await txn.insert('tasks', task.toMap());
        }

        // Import history
        for (final historyData in data['history'] as List) {
          final history = TaskHistory(
            id: historyData['id'],
            taskId: historyData['taskId'],
            title: historyData['title'],
            categoryId: historyData['categoryId'],
            points: historyData['points'],
            completedAt: DateTime.parse(historyData['completedAt']),
          );
          await txn.insert('task_history', history.toMap());
        }

        // Import statistics
        final stats = data['statistics'] as Map<String, dynamic>;
        for (final entry in stats.entries) {
          await txn.insert('statistics', {
            'date': entry.key,
            'tasksCompleted': entry.value['tasksCompleted'],
            'pointsEarned': entry.value['pointsEarned'],
            'rewardsRedeemed': entry.value['rewardsRedeemed'],
          });
        }
      });

      return true;
    } catch (e) {
      print('Error importing data: $e');
      return false;
    }
  }

  Future<bool> importFromFile(String filePath) async {
    try {
      final file = File(filePath);
      final jsonData = await file.readAsString();
      return importData(jsonData);
    } catch (e) {
      print('Error reading import file: $e');
      return false;
    }
  }
} 