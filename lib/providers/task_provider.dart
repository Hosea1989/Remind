import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/models/task_model.dart';
import 'package:remind/services/database_service.dart';
import 'package:remind/services/reminder_service.dart';

enum TaskSortOption {
  dueDate,
  points,
  title,
  category,
}

enum SortOrder {
  ascending,
  descending,
}

final taskListProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  final _db = DatabaseService();
  final _reminderService = ReminderService();

  TaskSortOption _sortOption = TaskSortOption.dueDate;
  SortOrder _sortOrder = SortOrder.ascending;

  TaskSortOption get sortOption => _sortOption;
  SortOrder get sortOrder => _sortOrder;

  void setSortOption(TaskSortOption option) {
    _sortOption = option;
    _sortTasks();
  }

  void toggleSortOrder() {
    _sortOrder = _sortOrder == SortOrder.ascending
        ? SortOrder.descending
        : SortOrder.ascending;
    _sortTasks();
  }

  void _sortTasks() {
    final tasks = [...state];
    final multiplier = _sortOrder == SortOrder.ascending ? 1 : -1;

    tasks.sort((a, b) {
      switch (_sortOption) {
        case TaskSortOption.dueDate:
          return a.dueDate.compareTo(b.dueDate) * multiplier;
        case TaskSortOption.points:
          return a.points.compareTo(b.points) * multiplier;
        case TaskSortOption.title:
          return a.title.compareTo(b.title) * multiplier;
        case TaskSortOption.category:
          return a.categoryId.compareTo(b.categoryId) * multiplier;
      }
    });

    state = tasks;
  }

  Future<void> _loadTasks() async {
    state = await _db.getTasks();
  }

  Future<void> addTask(Task task) async {
    await _db.insertTask(task);
    await _reminderService.scheduleReminder(task);
    state = [...state, task];
  }

  Future<void> deleteTask(String taskId) async {
    await _db.deleteTask(taskId);
    await _reminderService.cancelReminder(taskId);
    state = state.where((task) => task.id != taskId).toList();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final updatedTasks = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(isCompleted: !task.isCompleted)
        else
          task,
    ];
    
    final completedTask = updatedTasks.firstWhere((task) => task.id == taskId);
    if (completedTask.isCompleted) {
      await _reminderService.cancelReminder(taskId);
    } else {
      await _reminderService.scheduleReminder(completedTask);
    }
    
    await _db.updateTask(completedTask);
    state = updatedTasks;
  }
} 