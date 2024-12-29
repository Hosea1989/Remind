import 'package:flutter/material.dart';
import 'package:remind/models/reward_model.dart';
import 'package:remind/utils/constants.dart';
import 'package:uuid/uuid.dart';

class RewardDialog extends StatefulWidget {
  const RewardDialog({super.key});

  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _points = 100;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Reward'),
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
                  hintText: 'Enter reward title',
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
                  hintText: 'Enter reward description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Points Required:'),
                  Expanded(
                    child: Slider(
                      value: _points.toDouble(),
                      min: 50,
                      max: 500,
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
              final reward = Reward(
                id: const Uuid().v4(),
                title: _titleController.text,
                description: _descriptionController.text,
                points: _points,
              );
              Navigator.pop(context, reward);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
} 