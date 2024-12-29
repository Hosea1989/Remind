import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/models/template_model.dart';
import 'package:remind/providers/template_provider.dart';
import 'package:remind/models/category_model.dart';
import 'package:uuid/uuid.dart';

class TemplateFormDialog extends ConsumerStatefulWidget {
  final TaskTemplate? template;

  const TemplateFormDialog({
    super.key,
    this.template,
  });

  @override
  ConsumerState<TemplateFormDialog> createState() => _TemplateFormDialogState();
}

class _TemplateFormDialogState extends ConsumerState<TemplateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();
  String? _selectedCategoryId;
  Duration? _defaultDuration;

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _titleController.text = widget.template!.title;
      _descriptionController.text = widget.template!.description;
      _pointsController.text = widget.template!.points.toString();
      _selectedCategoryId = widget.template!.categoryId;
      _defaultDuration = widget.template!.defaultDuration;
    } else {
      _selectedCategoryId = TaskCategory.defaultCategories.first.id;
      _pointsController.text = '100';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.template == null ? 'New Template' : 'Edit Template'),
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
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
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
                        Icon(category.icon, color: category.color),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategoryId = value);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pointsController,
                decoration: const InputDecoration(
                  labelText: 'Points',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter points';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Default Duration'),
                subtitle: Text(_defaultDuration?.inDays == 1
                    ? '1 day'
                    : _defaultDuration?.inDays.toString() ?? 'None'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final days = await showDialog<int>(
                      context: context,
                      builder: (context) => _DurationPickerDialog(
                        initialDays: _defaultDuration?.inDays ?? 1,
                      ),
                    );
                    if (days != null) {
                      setState(() {
                        _defaultDuration = Duration(days: days);
                      });
                    }
                  },
                ),
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
        FilledButton(
          onPressed: _saveTemplate,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveTemplate() {
    if (_formKey.currentState!.validate()) {
      final template = TaskTemplate(
        id: widget.template?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        categoryId: _selectedCategoryId!,
        points: int.parse(_pointsController.text),
        defaultDuration: _defaultDuration,
      );

      if (widget.template == null) {
        ref.read(templateProvider.notifier).addTemplate(template);
      } else {
        ref.read(templateProvider.notifier).updateTemplate(template);
      }

      Navigator.pop(context);
    }
  }
}

class _DurationPickerDialog extends StatefulWidget {
  final int initialDays;

  const _DurationPickerDialog({
    required this.initialDays,
  });

  @override
  State<_DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<_DurationPickerDialog> {
  late int _days;

  @override
  void initState() {
    super.initState();
    _days = widget.initialDays;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Duration'),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _days > 1 ? () => setState(() => _days--) : null,
          ),
          Text('$_days days'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => _days++),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _days),
          child: const Text('Set'),
        ),
      ],
    );
  }
} 