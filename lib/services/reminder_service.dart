import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:remind/models/task_model.dart';
import 'package:shared_preferences.dart';

class ReminderService {
  static final ReminderService _instance = ReminderService._internal();
  factory ReminderService() => _instance;
  ReminderService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );
  }

  Future<bool> requestPermissions() async {
    final platform = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (platform != null) {
      await platform.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    return true;
  }

  Future<void> scheduleReminder(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.getBool('remindersEnabled') ?? true) return;

    final reminderTime = task.dueDate.subtract(const Duration(hours: 1));
    if (reminderTime.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      task.id.hashCode,
      'Task Reminder',
      'Task "${task.title}" is due in 1 hour',
      tz.TZDateTime.from(reminderTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Task Reminders',
          channelDescription: 'Notifications for task reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelReminder(String taskId) async {
    await _notifications.cancel(taskId.hashCode);
  }

  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }
} 