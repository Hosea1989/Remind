import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/screens/task_screen.dart';
import 'package:remind/screens/rewards_screen.dart';
import 'package:remind/screens/statistics_detail_screen.dart';
import 'package:remind/screens/achievements_screen.dart';
import 'package:remind/screens/settings_screen.dart';
import 'package:remind/screens/template_screen.dart';
import 'package:remind/services/reminder_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone data for notifications
  tz.initializeTimeZones();
  
  // Initialize notifications
  final reminderService = ReminderService();
  await reminderService.initialize();
  await reminderService.requestPermissions();

  runApp(
    const ProviderScope(
      child: RemindApp(),
    ),
  );
}

class RemindApp extends StatelessWidget {
  const RemindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remind',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    TaskScreen(),
    TemplateScreen(),
    RewardsScreen(),
    StatisticsDetailScreen(),
    AchievementsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.copy),
            label: 'Templates',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
} 