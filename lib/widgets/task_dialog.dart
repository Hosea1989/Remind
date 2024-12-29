import 'package:flutter/material.dart';
import 'package:remind/models/task_model.dart';
import 'package:remind/utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class TaskDialog extends StatefulWidget {
  final String? initialCategoryId;

  const TaskDialog({
    super.key,
    this.initialCategoryId,
  });

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate;
  late int _points;
  late String _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _points = AppConstants.defaultTaskPoints;
    _selectedCategoryId = widget.initialCategoryId ?? TaskCategory.defaultCategories[0].id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter task title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter task description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: TaskCategory.defaultCategories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Row(
                      children: [
                        Icon(category.icon, color: category.color, size: 20),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due Date'),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Points:'),
                  Expanded(
                    child: Slider(
                      value: _points.toDouble(),
                      min: AppConstants.minTaskPoints.toDouble(),
                      max: AppConstants.maxTaskPoints.toDouble(),
                      divisions: 9,
                      label: _points.toString(),
                      onChanged: (value) {
                        setState(() {
                          _points = value.round();
                        });
                      },
                    ),
                  ),
                  Text(_points.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final task = Task(
                id: const Uuid().v4(),
                title: _titleController.text,
                description: _descriptionController.text,
                dueDate: _selectedDate,
                points: _points,
                categoryId: _selectedCategoryId,
              );
              Navigator.pop(context, task);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
} 