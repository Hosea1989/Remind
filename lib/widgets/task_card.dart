import 'package:flutter/material.dart';
import 'package:remind/models/task_model.dart';
import 'package:remind/services/share_service.dart';

class TaskCard extends StatelessWidget {
  final Task? task;

  const TaskCard({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: task?.isCompleted ?? false,
              onChanged: (value) {
                // TODO: Implement task completion
              },
            ),
            title: Text(task?.title ?? 'Sample Task'),
            subtitle: Text(task?.description ?? 'Task description'),
            trailing: PopupMenuButton<String>(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share_json',
                  child: Row(
                    children: [
                      Icon(Icons.code),
                      SizedBox(width: 8),
                      Text('Share as JSON'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) async {
                if (task == null) return;
                
                switch (value) {
                  case 'share':
                    await ShareService.shareTask(task!);
                    break;
                  case 'share_json':
                    await ShareService.shareTask(task!, asJson: true);
                    break;
                  case 'edit':
                    // TODO: Implement edit
                    break;
                  case 'delete':
                    // TODO: Implement delete
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
} 