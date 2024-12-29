import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/services/statistics_service.dart';
import 'package:remind/models/task_model.dart';

class StatisticsState {
  final int completedTasks;
  final int totalPoints;
  final int currentStreak;

  const StatisticsState({
    required this.completedTasks,
    required this.totalPoints,
    required this.currentStreak,
  });

  StatisticsState copyWith({
    int? completedTasks,
    int? totalPoints,
    int? currentStreak,
  }) {
    return StatisticsState(
      completedTasks: completedTasks ?? this.completedTasks,
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}

final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
  return StatisticsNotifier();
});

class StatisticsNotifier extends StateNotifier<StatisticsState> {
  StatisticsNotifier()
      : super(const StatisticsState(
          completedTasks: 0,
          totalPoints: 0,
          currentStreak: 0,
        )) {
    _loadStatistics();
  }

  final _statisticsService = StatisticsService();

  Future<void> _loadStatistics() async {
    final stats = await _statisticsService.getStatistics();
    state = StatisticsState(
      completedTasks: stats['completedTasks']!,
      totalPoints: stats['totalPoints']!,
      currentStreak: stats['currentStreak']!,
    );
  }

  Future<void> recordTaskCompletion(Task task) async {
    await _statisticsService.recordTaskCompletion(task);
    await _loadStatistics();
  }

  Future<void> resetStatistics() async {
    await _statisticsService.resetStatistics();
    state = const StatisticsState(
      completedTasks: 0,
      totalPoints: 0,
      currentStreak: 0,
    );
  }
} 