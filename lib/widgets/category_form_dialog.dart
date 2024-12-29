import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/models/category_model.dart';
import 'package:remind/providers/category_provider.dart';
import 'package:uuid/uuid.dart';

class CategoryFormDialog extends ConsumerStatefulWidget {
  final TaskCategory? category;

  const CategoryFormDialog({
    super.key,
    this.category,
  });

  @override
  ConsumerState<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends ConsumerState<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late Color _selectedColor;
  late IconData _selectedIcon;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedColor = widget.category!.color;
      _selectedIcon = widget.category!.icon;
    } else {
      _selectedColor = Colors.blue;
      _selectedIcon = Icons.folder;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'New Category' : 'Edit Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _showIconPicker,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(_selectedIcon),
                          const SizedBox(width: 8),
                          const Text('Select Icon'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _showColorPicker,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveCategory,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _showIconPicker() {
    // Show a grid of common icons to choose from
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Icon'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            shrinkWrap: true,
            children: [
              Icons.folder,
              Icons.work,
              Icons.home,
              Icons.school,
              Icons.favorite,
              Icons.shopping_cart,
              Icons.sports,
              Icons.book,
              Icons.movie,
              Icons.music_note,
              Icons.restaurant,
              Icons.pets,
            ].map((icon) {
              return InkWell(
                onTap: () {
                  setState(() => _selectedIcon = icon);
                  Navigator.pop(context);
                },
                child: Icon(icon, size: 32),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    // Show a grid of material colors to choose from
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            shrinkWrap: true,
            children: Colors.primaries.map((color) {
              return InkWell(
                onTap: () {
                  setState(() => _selectedColor = color);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final category = TaskCategory(
        id: widget.category?.id ?? const Uuid().v4(),
        name: _nameController.text,
        icon: _selectedIcon,
        color: _selectedColor,
      );

      if (widget.category == null) {
        ref.read(categoryProvider.notifier).addCategory(category);
      } else {
        ref.read(categoryProvider.notifier).updateCategory(category);
      }

      Navigator.pop(context);
    }
  }
} 