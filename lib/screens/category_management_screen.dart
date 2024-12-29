import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/models/category_model.dart';
import 'package:remind/providers/category_provider.dart';
import 'package:remind/widgets/category_form_dialog.dart';

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CategoryFormDialog(),
              );
            },
          ),
        ],
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Dismissible(
            key: Key(category.id),
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
                  title: const Text('Delete Category'),
                  content: Text(
                    'Are you sure you want to delete "${category.name}"? '
                    'This will not delete tasks in this category.',
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
              ref.read(categoryProvider.notifier).deleteCategory(category.id);
            },
            child: Card(
              key: Key(category.id),
              child: ListTile(
                leading: Icon(category.icon, color: category.color),
                title: Text(category.name),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CategoryFormDialog(
                        category: category,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          ref.read(categoryProvider.notifier).reorderCategories(oldIndex, newIndex);
        },
      ),
    );
  }
} 