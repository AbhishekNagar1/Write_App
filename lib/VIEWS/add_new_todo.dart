import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_appwrite/controllers/todo_provider.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({super.key});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedPriority = 'medium';

  @override
  Widget build(BuildContext context) {
    TodoProvider provider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) => value!.isEmpty ? 'Title cannot be empty' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  maxLines: 5,
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  validator: (value) => value!.isEmpty ? 'Description cannot be empty' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    labelText: 'Priority',
                    prefixIcon: const Icon(Icons.flag),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'high', child: Text("High Priority")),
                    DropdownMenuItem(value: 'medium', child: Text("Medium Priority")),
                    DropdownMenuItem(value: 'low', child: Text("Low Priority")),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedPriority = value!);
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        provider.createNewTodo(
                          titleController.text,
                          descController.text,
                          _selectedPriority,
                        );
                        Fluttertoast.showToast(
                          msg: "Todo Added Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Create Task", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
