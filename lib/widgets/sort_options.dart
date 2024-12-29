import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/providers/task_provider.dart';

class SortOptions extends ConsumerWidget {
  const SortOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.read(taskListProvider.notifier);
    final currentOption = taskNotifier.sortOption;
    final currentOrder = taskNotifier.sortOrder;

    return Row(
      children: [
        const Text('Sort by:'),
        const SizedBox(width: 8),
        DropdownButton<TaskSortOption>(
          value: currentOption,
          items: TaskSortOption.values.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option.toString().split('.').last,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              taskNotifier.setSortOption(value);
            }
          },
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: Icon(
            currentOrder == SortOrder.ascending
                ? Icons.arrow_upward
                : Icons.arrow_downward,
          ),
          onPressed: () => taskNotifier.toggleSortOrder(),
          tooltip: 'Toggle sort order',
        ),
      ],
    );
  }
} 