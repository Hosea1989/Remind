import 'package:share_plus/share_plus.dart';
import 'package:remind/models/task_model.dart';
import 'package:remind/models/category_model.dart';
import 'dart:convert';

class ShareService {
  static Future<void> shareTask(Task task, {bool asJson = false}) async {
    if (asJson) {
      final taskData = {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate.toIso8601String(),
        'points': task.points,
        'categoryId': task.categoryId,
        'isCompleted': task.isCompleted,
      };
      
      await Share.share(
        jsonEncode(taskData),
        subject: 'Task: ${task.title}',
      );
    } else {
      final category = TaskCategory.defaultCategories
          .firstWhere((c) => c.id == task.categoryId);
          
      final shareText = '''
📋 Task: ${task.title}
📝 Description: ${task.description}
📅 Due Date: ${task.dueDate.toString().split(' ')[0]}
🏷️ Category: ${category.name}
⭐ Points: ${task.points}

Shared from Remind App
''';

      await Share.share(
        shareText,
        subject: 'Task: ${task.title}',
      );
    }
  }

  static Future<void> shareTaskList(List<Task> tasks, {bool asJson = false}) async {
    if (asJson) {
      final tasksData = tasks.map((task) => {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate.toIso8601String(),
        'points': task.points,
        'categoryId': task.categoryId,
        'isCompleted': task.isCompleted,
      }).toList();
      
      await Share.share(
        jsonEncode(tasksData),
        subject: 'Task List',
      );
    } else {
      final buffer = StringBuffer('📋 Task List\n\n');

      for (final task in tasks) {
        final category = TaskCategory.defaultCategories
            .firstWhere((c) => c.id == task.categoryId);
            
        buffer.writeln('• ${task.title}');
        if (task.description.isNotEmpty) {
          buffer.writeln('  ${task.description}');
        }
        buffer.writeln('  Due: ${task.dueDate.toString().split(' ')[0]}');
        buffer.writeln('  Category: ${category.name}');
        buffer.writeln('  Points: ${task.points}');
        buffer.writeln();
      }

      buffer.writeln('Shared from Remind App');

      await Share.share(
        buffer.toString(),
        subject: 'My Task List',
      );
    }
  }

  static Task? parseSharedTask(String jsonString) {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return Task(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        dueDate: DateTime.parse(data['dueDate']),
        points: data['points'],
        categoryId: data['categoryId'],
        isCompleted: data['isCompleted'],
      );
    } catch (e) {
      return null;
    }
  }

  static List<Task>? parseSharedTaskList(String jsonString) {
    try {
      final List<dynamic> data = jsonDecode(jsonString);
      return data.map((taskData) => Task(
        id: taskData['id'],
        title: taskData['title'],
        description: taskData['description'],
        dueDate: DateTime.parse(taskData['dueDate']),
        points: taskData['points'],
        categoryId: taskData['categoryId'],
        isCompleted: taskData['isCompleted'],
      )).toList();
    } catch (e) {
      return null;
    }
  }
} 