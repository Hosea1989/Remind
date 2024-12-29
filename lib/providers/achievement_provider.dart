import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/models/achievement_model.dart';
import 'package:shared_preferences.dart';

final achievementProvider = StateNotifierProvider<AchievementNotifier, List<Achievement>>((ref) {
  return AchievementNotifier();
});

class AchievementNotifier extends StateNotifier<List<Achievement>> {
  AchievementNotifier() : super([]) {
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedAchievements = prefs.getStringList('unlockedAchievements') ?? [];

    state = Achievement.defaultAchievements.map((achievement) {
      return achievement.copyWith(
        isUnlocked: unlockedAchievements.contains(achievement.id),
      );
    }).toList();
  }

  Future<void> checkAchievements({
    required int totalTasks,
    required int totalPoints,
    required int streak,
  }) async {
    final List<Achievement> updatedAchievements = [];
    final prefs = await SharedPreferences.getInstance();
    final unlockedAchievements = prefs.getStringList('unlockedAchievements') ?? [];

    for (final achievement in state) {
      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_task':
          shouldUnlock = totalTasks > 0;
          break;
        case 'task_master':
          shouldUnlock = totalTasks >= 10;
          break;
        case 'point_collector':
          shouldUnlock = totalPoints >= 1000;
          break;
        case 'streak_keeper':
          shouldUnlock = streak >= 7;
          break;
      }

      if (shouldUnlock && !achievement.isUnlocked) {
        unlockedAchievements.add(achievement.id);
        updatedAchievements.add(achievement.copyWith(isUnlocked: true));
      } else {
        updatedAchievements.add(achievement);
      }
    }

    if (updatedAchievements != state) {
      await prefs.setStringList('unlockedAchievements', unlockedAchievements);
      state = updatedAchievements;
    }
  }
} 