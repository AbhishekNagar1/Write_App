import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_appwrite/auth.dart';
import 'package:todo_app_appwrite/controllers/todo_provider.dart';
import 'package:todo_app_appwrite/shared.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  String _selectedPriority = 'all';

  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedPriority = value;
                todoProvider.readTodos(priority: _selectedPriority);
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text("All")),
              PopupMenuItem(value: 'high', child: Text("High Priority")),
              PopupMenuItem(value: 'medium', child: Text("Medium Priority")),
              PopupMenuItem(value: 'low', child: Text("Low Priority")),
            ],
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column( // Changed Row to Column to place text below image
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: const AssetImage('assets/images/user_avatar.png'),
                    // backgroundImage: AssetImage("assets/user_avatar.png"), // Change to actual user avatar
                  ),
                  SizedBox(height: 10), // Added spacing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome,",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${UserSavedData.getEmail}",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView( // Using ListView to prevent overflow
                children: [
                  ListTile(
                    leading: Icon(Icons.delete_forever, color: Colors.red),
                    title: Text("Delete All Todos"),
                    onTap: () {
                      todoProvider.deleteAllTodos().then((_) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("All Todos Deleted")),
                        );
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.blue),
                    title: Text("Logout"),
                    onTap: () {
                      logoutUser().then(
                            (_) => Navigator.pushReplacementNamed(context, '/'),
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Made by Abhishek Nagar with 💖",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.copyright, size: 16),
                      SizedBox(width: 5),
                      Text("All rights reserved 2025"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),




      body: _selectedIndex == 0 ? showOngoingTodos() : showCompletedTodos(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() {
          _selectedIndex = value;
        }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Todo List"),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: "Completed"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/new');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget showOngoingTodos() {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        final filteredTodos = provider.allTodos.where((todo) {
          if (_selectedPriority == 'all') return !todo.data['isDone'];
          return !todo.data['isDone'] && todo.data['priority'] == _selectedPriority;
        }).toList();

        return provider.checkLoading
            ? Center(child: CircularProgressIndicator())
            : filteredTodos.isEmpty
            ? Center(child: Text("No Todos"))
            : ListView.builder(
          itemCount: filteredTodos.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/edit', arguments: filteredTodos[index]);
              },
              title: Text(filteredTodos[index].data['title']),
              subtitle: Text(filteredTodos[index].data['description']),
              leading: Checkbox(
                value: filteredTodos[index].data['isDone'] ?? false,
                onChanged: (value) {
                  provider.markCompleted(filteredTodos[index].$id, value ?? false);
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _priorityTag(filteredTodos[index].data['priority']),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      provider.deleteTodo(filteredTodos[index].$id);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget showCompletedTodos() {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        final filteredTodos = provider.allTodos.where((todo) {
          if (_selectedPriority == 'all') return todo.data['isDone'];
          return todo.data['isDone'] && todo.data['priority'] == _selectedPriority;
        }).toList();

        return provider.checkLoading
            ? Center(child: CircularProgressIndicator())
            : filteredTodos.isEmpty
            ? Center(child: Text("No Todos Completed"))
            : ListView.builder(
          itemCount: filteredTodos.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Checkbox(
                value: filteredTodos[index].data['isDone'] ?? false,
                onChanged: (value) {
                  provider.markCompleted(filteredTodos[index].$id, value ?? false);
                },
              ),
              title: Text(filteredTodos[index].data['title']),
              subtitle: Text(filteredTodos[index].data['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _priorityTag(filteredTodos[index].data['priority']),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      provider.deleteTodo(filteredTodos[index].$id);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _priorityTag(String priority) {
    Color color;
    switch (priority) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
