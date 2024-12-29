import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/services/points_service.dart';

final pointsProvider = StateNotifierProvider<PointsNotifier, PointsState>((ref) {
  return PointsNotifier();
});

class PointsState {
  final int totalPoints;
  final int availablePoints;

  PointsState({
    required this.totalPoints,
    required this.availablePoints,
  });

  PointsState copyWith({
    int? totalPoints,
    int? availablePoints,
  }) {
    return PointsState(
      totalPoints: totalPoints ?? this.totalPoints,
      availablePoints: availablePoints ?? this.availablePoints,
    );
  }
}

class PointsNotifier extends StateNotifier<PointsState> {
  PointsNotifier()
      : super(PointsState(totalPoints: 0, availablePoints: 0)) {
    _loadPoints();
  }

  final _pointsService = PointsService();

  Future<void> _loadPoints() async {
    state = PointsState(
      totalPoints: _pointsService.totalPoints,
      availablePoints: _pointsService.availablePoints,
    );
  }

  Future<void> addPoints(int points) async {
    await _pointsService.addPoints(points);
    state = state.copyWith(
      totalPoints: state.totalPoints + points,
      availablePoints: state.availablePoints + points,
    );
  }

  Future<bool> spendPoints(int points) async {
    final success = await _pointsService.spendPoints(points);
    if (success) {
      state = state.copyWith(
        availablePoints: state.availablePoints - points,
      );
    }
    return success;
  }
} 