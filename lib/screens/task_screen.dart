import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/models/task_model.dart';
import 'package:remind/models/task_template_model.dart';
import 'package:remind/providers/task_provider.dart';
import 'package:remind/widgets/task_card.dart';
import 'package:remind/widgets/task_dialog.dart';
import 'package:remind/widgets/category_filter.dart';
import 'package:remind/widgets/sort_options.dart';
import 'package:remind/widgets/template_dialog.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    final filteredTasks = _selectedCategoryId == null
        ? tasks
        : tasks.where((task) => task.categoryId == _selectedCategoryId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Expanded(child: SortOptions()),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // TODO: Implement search
                  },
                ),
              ],
            ),
          ),
          CategoryFilter(
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() {
                _selectedCategoryId = categoryId;
              });
            },
          ),
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text('No tasks yet. Create one by tapping the + button!'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(task: filteredTasks[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'template',
            onPressed: () async {
              final TaskTemplate? template = await showDialog<TaskTemplate>(
                context: context,
                builder: (context) => const TemplateDialog(),
              );

              if (template != null) {
                final task = template.toTask();
                ref.read(taskListProvider.notifier).addTask(task);
              }
            },
            child: const Icon(Icons.copy),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () async {
              final Task? newTask = await showDialog<Task>(
                context: context,
                builder: (context) => TaskDialog(
                  initialCategoryId: _selectedCategoryId,
                ),
              );

              if (newTask != null) {
                ref.read(taskListProvider.notifier).addTask(newTask);
              }
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
} 