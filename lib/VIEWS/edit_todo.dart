import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_appwrite/controllers/todo_provider.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({super.key});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String _selectedPriority = 'medium'; // Default priority

  @override
  Widget build(BuildContext context) {
    TodoProvider provider = Provider.of<TodoProvider>(context);

    // Catch the arguments
    final Document arguments =
    ModalRoute.of(context)?.settings.arguments as Document;
    titleController.text = arguments.data['title'];
    descController.text = arguments.data['description'];
    _selectedPriority = arguments.data['priority'] ?? 'medium'; // Set initial priority

    return Scaffold(
      appBar: AppBar(title: Text("Edit Todo")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("Title")),
            ),
            SizedBox(height: 10),
            TextFormField(
              maxLines: 8,
              controller: descController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text("Description")),
            ),
            SizedBox(height: 10),
            // Priority Dropdown
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Priority',
              ),
              items: [
                DropdownMenuItem(value: 'high', child: Text("High Priority")),
                DropdownMenuItem(value: 'medium', child: Text("Medium Priority")),
                DropdownMenuItem(value: 'low', child: Text("Low Priority")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                provider.updateTodo(
                  titleController.text,
                  descController.text,
                  arguments.$id,
                  _selectedPriority, // Pass priority
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Todo Updated")),
                );
                Navigator.pop(context);
              },
              child: Text("Update Todo"),
            ),
          ]),
        ),
      ),
    );
  }
}