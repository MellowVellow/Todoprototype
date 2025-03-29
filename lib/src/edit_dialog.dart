import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'models/dashboard_item_model.dart';

class EditItemDialog extends HookWidget {
  const EditItemDialog({
    super.key,
    this.initialData,
  });

  final DashboardItemData? initialData;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(
      text: initialData?.title,
    );
    final descController = useTextEditingController(
      text: initialData?.description,
    );
    final categoryController = useState(initialData?.category ?? 'Work');
    final durationController = useTextEditingController(
      text: initialData?.duration.inMinutes.toString(),
    );
    final priorityController = useTextEditingController(
      text: initialData?.priority.toString() ?? '1',
    );

    return AlertDialog(
      title: const Text('Edit Item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: categoryController.value,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  categoryController.value = newValue;
                }
              },
              items: <String>['Work', 'Personal', 'Urgent', 'Hobby']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priorityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Priority (1-4)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(DashboardItemData(
              title: titleController.text,
              description: descController.text,
              category: categoryController.value,
              duration:
                  Duration(minutes: int.tryParse(durationController.text) ?? 0),
              priority: int.tryParse(priorityController.text) ?? 1,
            ));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
