import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/providers/template_provider.dart';
import 'package:remind/providers/task_provider.dart';
import 'package:remind/widgets/template_form_dialog.dart';
import 'package:remind/utils/constants.dart';
import 'package:remind/models/category_model.dart';

class TemplateScreen extends ConsumerWidget {
  const TemplateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const TemplateFormDialog(),
              );
            },
          ),
        ],
      ),
      body: templates.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.copy,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No templates yet',
                    style: AppConstants.headerStyle.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create templates for frequently used tasks',
                    style: AppConstants.bodyStyle.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const TemplateFormDialog(),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Template'),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                final category = TaskCategory.defaultCategories
                    .firstWhere((c) => c.id == template.categoryId);

                return Dismissible(
                  key: Key(template.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Template'),
                        content: Text(
                          'Are you sure you want to delete "${template.title}"?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) {
                    ref.read(templateProvider.notifier).deleteTemplate(template.id);
                  },
                  child: Card(
                    key: Key(template.id),
                    child: ListTile(
                      leading: Icon(category.icon, color: category.color),
                      title: Text(template.title),
                      subtitle: Text(template.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${template.points} pts',
                            style: AppConstants.bodyStyle.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          PopupMenuButton<String>(
                            itemBuilder: (context) => [
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
                                value: 'use',
                                child: Row(
                                  children: [
                                    Icon(Icons.add_task),
                                    SizedBox(width: 8),
                                    Text('Create Task'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                showDialog(
                                  context: context,
                                  builder: (context) => TemplateFormDialog(
                                    template: template,
                                  ),
                                );
                              } else if (value == 'use') {
                                final task = template.toTask();
                                ref.read(taskListProvider.notifier).addTask(task);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Task created from template'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              onReorder: (oldIndex, newIndex) {
                ref
                    .read(templateProvider.notifier)
                    .reorderTemplates(oldIndex, newIndex);
              },
            ),
    );
  }
} 