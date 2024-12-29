import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/models/category_model.dart';
import 'package:shared_preferences.dart';
import 'dart:convert';

final categoryProvider = StateNotifierProvider<CategoryNotifier, List<TaskCategory>>((ref) {
  return CategoryNotifier();
});

class CategoryNotifier extends StateNotifier<List<TaskCategory>> {
  CategoryNotifier() : super([]) {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final customCategories = prefs.getStringList('customCategories') ?? [];
    
    // Start with default categories
    final categories = [...TaskCategory.defaultCategories];
    
    // Add custom categories
    for (final categoryJson in customCategories) {
      final data = jsonDecode(categoryJson);
      categories.add(TaskCategory(
        id: data['id'],
        name: data['name'],
        icon: IconData(data['iconCode'], fontFamily: 'MaterialIcons'),
        color: Color(data['colorValue']),
      ));
    }
    
    state = categories;
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final customCategories = state
        .where((category) => !TaskCategory.defaultCategories
            .any((defaultCategory) => defaultCategory.id == category.id))
        .map((category) => jsonEncode({
              'id': category.id,
              'name': category.name,
              'iconCode': category.icon.codePoint,
              'colorValue': category.color.value,
            }))
        .toList();
    
    await prefs.setStringList('customCategories', customCategories);
  }

  void addCategory(TaskCategory category) {
    state = [...state, category];
    _saveCategories();
  }

  void updateCategory(TaskCategory updatedCategory) {
    state = [
      for (final category in state)
        if (category.id == updatedCategory.id) updatedCategory else category,
    ];
    _saveCategories();
  }

  void deleteCategory(String categoryId) {
    // Don't allow deleting default categories
    if (TaskCategory.defaultCategories
        .any((category) => category.id == categoryId)) {
      return;
    }
    
    state = state.where((category) => category.id != categoryId).toList();
    _saveCategories();
  }

  void reorderCategories(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final categories = [...state];
    final item = categories.removeAt(oldIndex);
    categories.insert(newIndex, item);
    state = categories;
    _saveCategories();
  }
} 