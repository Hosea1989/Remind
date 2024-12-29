import 'package:flutter/material.dart';
import 'package:remind/services/export_service.dart';
import 'package:remind/utils/constants.dart';
import 'package:file_picker/file_picker.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildSection(
            title: 'Backup',
            description: 'Create a backup of your tasks, history, and statistics.',
            icon: Icons.backup,
            onPressed: () async {
              try {
                await ExportService().exportToFile();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup created successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error creating backup: $e')),
                );
              }
            },
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Restore',
            description: 'Restore your data from a backup file. '
                'Warning: This will replace all current data.',
            icon: Icons.restore,
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Restore Data'),
                  content: const Text(
                    'This will replace all current data with the backup data. '
                    'This action cannot be undone. Continue?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Restore'),
                    ),
                  ],
                ),
              );

              if (result == true) {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                );

                if (result != null) {
                  final success = await ExportService()
                      .importFromFile(result.files.single.path!);
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Data restored successfully'
                              : 'Error restoring data',
                        ),
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: 16),
                  Text(title, style: AppConstants.headerStyle),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: AppConstants.bodyStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 