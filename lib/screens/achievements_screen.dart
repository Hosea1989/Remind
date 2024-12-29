import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/providers/achievement_provider.dart';
import 'package:remind/utils/constants.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return Card(
            child: ListTile(
              leading: Text(
                achievement.icon,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(
                achievement.title,
                style: TextStyle(
                  color: achievement.isUnlocked
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(achievement.description),
              trailing: achievement.isUnlocked
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.lock, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
} 