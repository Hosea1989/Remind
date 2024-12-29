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

  // Add some default categories
  static const List<TaskCategory> defaultCategories = [
    TaskCategory(
      id: 'work',
      name: 'Work',
      icon: Icons.work,
      color: Colors.blue,
    ),
    TaskCategory(
      id: 'personal',
      name: 'Personal',
      icon: Icons.person,
      color: Colors.green,
    ),
    TaskCategory(
      id: 'health',
      name: 'Health',
      icon: Icons.favorite,
      color: Colors.red,
    ),
    TaskCategory(
      id: 'study',
      name: 'Study',
      icon: Icons.school,
      color: Colors.purple,
    ),
  ];
} 