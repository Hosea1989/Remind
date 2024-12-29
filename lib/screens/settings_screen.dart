import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/utils/constants.dart';
import 'package:remind/screens/backup_screen.dart';
import 'package:remind/screens/category_management_screen.dart';
import 'package:shared_preferences.dart';

final reminderEnabledProvider = StateNotifierProvider<ReminderEnabledNotifier, bool>((ref) {
  return ReminderEnabledNotifier();
});

class ReminderEnabledNotifier extends StateNotifier<bool> {
  ReminderEnabledNotifier() : super(true) {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('remindersEnabled') ?? true;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    state = !state;
    await prefs.setBool('remindersEnabled', state);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersEnabled = ref.watch(reminderEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'General',
            children: [
              SwitchListTile(
                title: const Text('Enable Reminders'),
                subtitle: const Text('Receive notifications for upcoming tasks'),
                value: remindersEnabled,
                onChanged: (_) {
                  ref.read(reminderEnabledProvider.notifier).toggle();
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Organization',
            children: [
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Manage Categories'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryManagementScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Data',
            children: [
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Backup & Restore'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BackupScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Remind',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2024',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: AppConstants.subheaderStyle.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        ...children,
      ],
    );
  }
} 