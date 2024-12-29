import 'package:shared_preferences.dart';

class PointsService {
  static final PointsService _instance = PointsService._internal();
  factory PointsService() => _instance;
  PointsService._internal();

  static const String _totalPointsKey = 'totalPoints';
  static const String _availablePointsKey = 'availablePoints';

  late final SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get totalPoints => _prefs.getInt(_totalPointsKey) ?? 0;
  int get availablePoints => _prefs.getInt(_availablePointsKey) ?? 0;

  Future<void> addPoints(int points) async {
    final newTotal = totalPoints + points;
    final newAvailable = availablePoints + points;
    await _prefs.setInt(_totalPointsKey, newTotal);
    await _prefs.setInt(_availablePointsKey, newAvailable);
  }

  Future<bool> spendPoints(int points) async {
    if (availablePoints < points) return false;
    
    final newAvailable = availablePoints - points;
    await _prefs.setInt(_availablePointsKey, newAvailable);
    return true;
  }
} 