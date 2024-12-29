class UserProfile {
  final String id;
  final String name;
  final String email;
  final DateTime joinDate;
  final int streak; // Days in a row with completed tasks
  final Map<String, int> statistics; // Key-value pairs for various stats

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.joinDate,
    this.streak = 0,
    Map<String, int>? statistics,
  }) : statistics = statistics ?? {};

  UserProfile copyWith({
    String? name,
    String? email,
    int? streak,
    Map<String, int>? statistics,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      joinDate: joinDate,
      streak: streak ?? this.streak,
      statistics: statistics ?? this.statistics,
    );
  }
} 