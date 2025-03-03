import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_appwrite/controllers/todo_provider.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({super.key});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String _selectedPriority = 'medium'; // Default priority

  @override
  Widget build(BuildContext context) {
    TodoProvider provider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Add New Todo")),
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
                provider.createNewTodo(
                  titleController.text,
                  descController.text,
                  _selectedPriority, // Pass priority
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Todo Added")),
                );
                Navigator.pop(context);
              },
              child: Text("Create Todo"),
            ),
          ]),
        ),
      ),
    );
  }
}