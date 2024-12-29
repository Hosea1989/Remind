class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int pointsRequired;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.pointsRequired,
    this.isUnlocked = false,
  });

  Achievement copyWith({
    String? title,
    String? description,
    String? icon,
    int? pointsRequired,
    bool? isUnlocked,
  }) {
    return Achievement(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  static const List<Achievement> defaultAchievements = [
    Achievement(
      id: 'first_task',
      title: 'First Steps',
      description: 'Complete your first task',
      icon: '🎯',
      pointsRequired: 0,
    ),
    Achievement(
      id: 'task_master',
      title: 'Task Master',
      description: 'Complete 10 tasks',
      icon: '🏆',
      pointsRequired: 500,
    ),
    Achievement(
      id: 'point_collector',
      title: 'Point Collector',
      description: 'Earn 1000 points',
      icon: '⭐',
      pointsRequired: 1000,
    ),
    Achievement(
      id: 'streak_keeper',
      title: 'Streak Keeper',
      description: 'Maintain a 7-day streak',
      icon: '🔥',
      pointsRequired: 0,
    ),
  ];
} 