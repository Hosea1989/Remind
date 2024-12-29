import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:remind/models/task_model.dart';
import 'package:remind/models/reward_model.dart';
import 'package:remind/models/user_profile_model.dart';
import 'package:remind/services/database_service.dart';

class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  final _db = DatabaseService();

  Future<String> exportData() async {
    // Gather all data
    final tasks = await _db.getTasks();
    final rewards = await _db.getRewards();
    final userProfile = await _db.getUserProfile('current_user'); // Assuming single user

    // Create backup object
    final backupData = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'tasks': tasks.map((task) => {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate.toIso8601String(),
        'points': task.points,
        'categoryId': task.categoryId,
        'isCompleted': task.isCompleted,
      }).toList(),
      'rewards': rewards.map((reward) => {
        'id': reward.id,
        'title': reward.title,
        'description': reward.description,
        'points': reward.points,
        'isAvailable': reward.isAvailable,
      }).toList(),
      'userProfile': userProfile != null ? {
        'id': userProfile.id,
        'name': userProfile.name,
        'email': userProfile.email,
        'joinDate': userProfile.joinDate.toIso8601String(),
        'streak': userProfile.streak,
        'statistics': userProfile.statistics,
      } : null,
    };

    // Convert to JSON string
    return jsonEncode(backupData);
  }

  Future<void> importData(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      
      // Verify version compatibility
      final version = data['version'] as int;
      if (version != 1) {
        throw Exception('Unsupported backup version');
      }

      // Import tasks
      final tasks = (data['tasks'] as List).map((taskData) => Task(
        id: taskData['id'],
        title: taskData['title'],
        description: taskData['description'],
        dueDate: DateTime.parse(taskData['dueDate']),
        points: taskData['points'],
        categoryId: taskData['categoryId'],
        isCompleted: taskData['isCompleted'],
      )).toList();

      // Import rewards
      final rewards = (data['rewards'] as List).map((rewardData) => Reward(
        id: rewardData['id'],
        title: rewardData['title'],
        description: rewardData['description'],
        points: rewardData['points'],
        isAvailable: rewardData['isAvailable'],
      )).toList();

      // Clear existing data
      await _clearDatabase();

      // Insert new data
      for (final task in tasks) {
        await _db.insertTask(task);
      }
      for (final reward in rewards) {
        await _db.insertReward(reward);
      }

      // Import user profile if exists
      if (data['userProfile'] != null) {
        final profileData = data['userProfile'];
        final userProfile = UserProfile(
          id: profileData['id'],
          name: profileData['name'],
          email: profileData['email'],
          joinDate: DateTime.parse(profileData['joinDate']),
          streak: profileData['streak'],
          statistics: Map<String, int>.from(profileData['statistics']),
        );
        await _db.updateUserProfile(userProfile);
      }
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  Future<void> _clearDatabase() async {
    final db = await _db.database;
    await db.delete('tasks');
    await db.delete('rewards');
    await db.delete('user_profile');
    await db.delete('statistics');
  }

  Future<File> saveBackupToFile() async {
    final data = await exportData();
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/remind_backup_${DateTime.now().toIso8601String()}.json');
    return file.writeAsString(data);
  }

  Future<void> restoreFromFile(File file) async {
    final data = await file.readAsString();
    await importData(data);
  }
} 