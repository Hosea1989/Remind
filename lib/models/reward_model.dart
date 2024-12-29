class Reward {
  final String id;
  final String title;
  final String description;
  final int points;
  final bool isAvailable;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.isAvailable = true,
  });

  Reward copyWith({
    String? id,
    String? title,
    String? description,
    int? points,
    bool? isAvailable,
  }) {
    return Reward(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
} 