import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/utils/routes.dart';
import 'package:remind/utils/theme.dart';
import 'package:remind/screens/home_screen.dart';
import 'package:remind/services/notification_service.dart';
import 'package:remind/services/settings_service.dart';
import 'package:remind/services/points_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await NotificationService().initialize();
  await SettingsService().initialize();
  await PointsService().initialize();

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
      theme: AppTheme.lightTheme, // We'll define this in theme.dart
      darkTheme: AppTheme.darkTheme, // We'll define this in theme.dart
      routes: AppRoutes.routes, // We'll define this in routes.dart
      home: const HomeScreen(), // We'll create this in screens/home_screen.dart
    );
  }
}
