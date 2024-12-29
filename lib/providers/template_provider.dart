import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/models/template_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final templateProvider =
    StateNotifierProvider<TemplateNotifier, List<TaskTemplate>>((ref) {
  return TemplateNotifier();
});

class TemplateNotifier extends StateNotifier<List<TaskTemplate>> {
  TemplateNotifier() : super([]) {
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final templatesJson = prefs.getStringList('taskTemplates') ?? [];
    
    state = templatesJson
        .map((json) => TaskTemplate.fromMap(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final templatesJson = state
        .map((template) => jsonEncode(template.toMap()))
        .toList();
    
    await prefs.setStringList('taskTemplates', templatesJson);
  }

  Future<void> addTemplate(TaskTemplate template) async {
    state = [...state, template];
    await _saveTemplates();
  }

  Future<void> updateTemplate(TaskTemplate template) async {
    state = [
      for (final t in state)
        if (t.id == template.id) template else t,
    ];
    await _saveTemplates();
  }

  Future<void> deleteTemplate(String id) async {
    state = state.where((t) => t.id != id).toList();
    await _saveTemplates();
  }

  Future<void> reorderTemplates(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final templates = [...state];
    final item = templates.removeAt(oldIndex);
    templates.insert(newIndex, item);
    state = templates;
    await _saveTemplates();
  }
} 