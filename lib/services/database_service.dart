import 'package:remind/models/task_model.dart';
import 'package:remind/models/reward_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'remind.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        dueDate INTEGER NOT NULL,
        points INTEGER NOT NULL,
        categoryId TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE rewards(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        points INTEGER NOT NULL,
        isAvailable INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profile(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        joinDate INTEGER NOT NULL,
        streak INTEGER NOT NULL,
        statistics TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE statistics(
        date TEXT NOT NULL,
        tasksCompleted INTEGER NOT NULL,
        pointsEarned INTEGER NOT NULL,
        rewardsRedeemed INTEGER NOT NULL,
        PRIMARY KEY (date)
      )
    ''');

    await db.execute('''
      CREATE TABLE task_history (
        id TEXT PRIMARY KEY,
        task_id TEXT NOT NULL,
        title TEXT NOT NULL,
        category_id TEXT NOT NULL,
        points INTEGER NOT NULL,
        completed_at TEXT NOT NULL
      )
    ''');
  }

  // Task CRUD operations
  Future<List<Task>> getTasks({String? categoryId}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: categoryId != null ? 'categoryId = ?' : null,
      whereArgs: categoryId != null ? [categoryId] : null,
    );
    
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        dueDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['dueDate']),
        points: maps[i]['points'],
        categoryId: maps[i]['categoryId'],
        isCompleted: maps[i]['isCompleted'] == 1,
      );
    });
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'dueDate': task.dueDate.millisecondsSinceEpoch,
        'points': task.points,
        'categoryId': task.categoryId,
        'isCompleted': task.isCompleted ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Reward CRUD operations
  Future<List<Reward>> getRewards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('rewards');
    return List.generate(maps.length, (i) {
      return Reward(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        points: maps[i]['points'],
        isAvailable: maps[i]['isAvailable'] == 1,
      );
    });
  }

  Future<void> insertReward(Reward reward) async {
    final db = await database;
    await db.insert(
      'rewards',
      {
        'id': reward.id,
        'title': reward.title,
        'description': reward.description,
        'points': reward.points,
        'isAvailable': reward.isAvailable ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateReward(Reward reward) async {
    final db = await database;
    await db.update(
      'rewards',
      {
        'title': reward.title,
        'description': reward.description,
        'points': reward.points,
        'isAvailable': reward.isAvailable ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [reward.id],
    );
  }

  Future<void> deleteReward(String id) async {
    final db = await database;
    await db.delete(
      'rewards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<UserProfile?> getUserProfile(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_profile',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return UserProfile(
      id: maps[0]['id'],
      name: maps[0]['name'],
      email: maps[0]['email'],
      joinDate: DateTime.fromMillisecondsSinceEpoch(maps[0]['joinDate']),
      streak: maps[0]['streak'],
      statistics: Map<String, int>.from(
        // Convert JSON string to Map
        jsonDecode(maps[0]['statistics']),
      ),
    );
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final db = await database;
    await db.update(
      'user_profile',
      {
        'name': profile.name,
        'email': profile.email,
        'streak': profile.streak,
        'statistics': jsonEncode(profile.statistics),
      },
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<void> recordDailyStatistics({
    required int tasksCompleted,
    required int pointsEarned,
    required int rewardsRedeemed,
  }) async {
    final db = await database;
    final date = DateTime.now().toIso8601String().split('T')[0];

    await db.insert(
      'statistics',
      {
        'date': date,
        'tasksCompleted': tasksCompleted,
        'pointsEarned': pointsEarned,
        'rewardsRedeemed': rewardsRedeemed,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, int>> getStatisticsForRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final startDate = start.toIso8601String().split('T')[0];
    final endDate = end.toIso8601String().split('T')[0];

    final List<Map<String, dynamic>> maps = await db.query(
      'statistics',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
    );

    return {
      'tasksCompleted': maps.fold(0, (sum, item) => sum + item['tasksCompleted'] as int),
      'pointsEarned': maps.fold(0, (sum, item) => sum + item['pointsEarned'] as int),
      'rewardsRedeemed': maps.fold(0, (sum, item) => sum + item['rewardsRedeemed'] as int),
    };
  }
} 