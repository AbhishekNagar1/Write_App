import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app_appwrite/controllers/todo_provider.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({super.key});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String _selectedPriority = 'medium';
  late String todoId; // Store the ID separately

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Document) {
      titleController.text = arguments.data['title'];
      descController.text = arguments.data['description'];
      _selectedPriority = arguments.data['priority'] ?? 'medium';
      todoId = arguments.$id; // Extract ID
    } else {
      Fluttertoast.showToast(
        msg: "Error: Invalid Todo Data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    TodoProvider provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Todo"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Title",
                  prefixIcon: const Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 6,
                controller: descController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: "Description",
                  prefixIcon: const Icon(Icons.description),
                ),
              ),
              // const SizedBox(height: 16),
              // DropdownButtonFormField<String>(
              //   value: _selectedPriority,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     labelText: 'Priority',
              //     prefixIcon: const Icon(Icons.priority_high),
              //   ),
              //   items: const [
              //     DropdownMenuItem(value: 'high', child: Text("High Priority")),
              //     DropdownMenuItem(value: 'medium', child: Text("Medium Priority")),
              //     DropdownMenuItem(value: 'low', child: Text("Low Priority")),
              //   ],
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedPriority = value!;
              //     });
              //   },
              // ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await provider.updateTodo(
                        todoId,
                        titleController.text,
                        descController.text,
                        _selectedPriority,
                      );
                      Fluttertoast.showToast(
                        msg: "Todo Updated Successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      Fluttertoast.showToast(
                        msg: "Failed to update Todo: $e",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  child: const Text("Update Task", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
