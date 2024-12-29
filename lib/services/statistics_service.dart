import 'package:shared_preferences.dart';
import 'package:remind/models/task_model.dart';

class StatisticsService {
  static final StatisticsService _instance = StatisticsService._internal();
  factory StatisticsService() => _instance;
  StatisticsService._internal();

  static const String _completedTasksKey = 'completedTasks';
  static const String _totalPointsKey = 'totalPoints';
  static const String _currentStreakKey = 'currentStreak';
  static const String _lastCompletionDateKey = 'lastCompletionDate';

  Future<void> recordTaskCompletion(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Update completed tasks count
    final completedTasks = prefs.getInt(_completedTasksKey) ?? 0;
    await prefs.setInt(_completedTasksKey, completedTasks + 1);

    // Update total points
    final totalPoints = prefs.getInt(_totalPointsKey) ?? 0;
    await prefs.setInt(_totalPointsKey, totalPoints + task.points);

    // Update streak
    final lastCompletionDate = prefs.getString(_lastCompletionDateKey);
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    if (lastCompletionDate != null) {
      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String()
          .split('T')[0];
      
      if (lastCompletionDate == yesterday) {
        final currentStreak = prefs.getInt(_currentStreakKey) ?? 0;
        await prefs.setInt(_currentStreakKey, currentStreak + 1);
      } else if (lastCompletionDate != today) {
        await prefs.setInt(_currentStreakKey, 1);
      }
    } else {
      await prefs.setInt(_currentStreakKey, 1);
    }

    await prefs.setString(_lastCompletionDateKey, today);
  }

  Future<Map<String, int>> getStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'completedTasks': prefs.getInt(_completedTasksKey) ?? 0,
      'totalPoints': prefs.getInt(_totalPointsKey) ?? 0,
      'currentStreak': prefs.getInt(_currentStreakKey) ?? 0,
    };
  }

  Future<void> resetStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedTasksKey);
    await prefs.remove(_totalPointsKey);
    await prefs.remove(_currentStreakKey);
    await prefs.remove(_lastCompletionDateKey);
  }
} 