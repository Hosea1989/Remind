class UserProfile {
  final String id;
  final String name;
  final String email;
  final DateTime joinDate;
  final int streak;
  final Map<String, int> statistics;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.joinDate,
    required this.streak,
    required this.statistics,
  });
} 