import 'package:flutter/material.dart';

class TaskCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  static final List<TaskCategory> defaultCategories = [
    TaskCategory(
      id: '1',
      name: 'General',
      icon: Icons.list,
      color: Colors.blue,
    ),
    TaskCategory(
      id: '2',
      name: 'Work',
      icon: Icons.work,
      color: Colors.orange,
    ),
    TaskCategory(
      id: '3',
      name: 'Personal',
      icon: Icons.person,
      color: Colors.green,
    ),
  ];
} 