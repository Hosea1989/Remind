import 'package:flutter/material.dart';
import 'package:remind/models/category_model.dart';

class CategoryFilter extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const CategoryFilter({
    super.key,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: TaskCategory.defaultCategories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryChip(
              context,
              null,
              'All',
              Icons.list,
              Colors.grey,
            );
          }
          
          final category = TaskCategory.defaultCategories[index - 1];
          return _buildCategoryChip(
            context,
            category.id,
            category.name,
            category.icon,
            category.color,
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String? categoryId,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = selectedCategoryId == categoryId;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (_) => onCategorySelected(categoryId),
        backgroundColor: Colors.white,
        selectedColor: color,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
} 