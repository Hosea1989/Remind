import 'package:flutter/material.dart';
import 'package:remind/screens/home_screen.dart';
import 'package:remind/screens/task_screen.dart';
import 'package:remind/screens/reward_screen.dart';
import 'package:remind/screens/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String tasks = '/tasks';
  static const String rewards = '/rewards';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    tasks: (context) => const TaskScreen(),
    rewards: (context) => const RewardScreen(),
    settings: (context) => const SettingsScreen(),
  };
} 