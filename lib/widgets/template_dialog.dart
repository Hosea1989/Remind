import 'package:flutter/material.dart';
import 'package:remind/models/task_template_model.dart';
import 'package:remind/models/category_model.dart';

class TemplateDialog extends StatelessWidget {
  const TemplateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Template'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: TaskTemplate.defaultTemplates.length,
          itemBuilder: (context, index) {
            final template = TaskTemplate.defaultTemplates[index];
            final category = TaskCategory.defaultCategories
                .firstWhere((c) => c.id == template.categoryId);

            return ListTile(
              leading: Icon(category.icon, color: category.color),
              title: Text(template.title),
              subtitle: Text(template.description),
              trailing: Text('${template.points} pts'),
              onTap: () {
                Navigator.pop(context, template);
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
} 