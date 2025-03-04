// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_app_appwrite/auth.dart';
// import 'package:todo_app_appwrite/controllers/todo_provider.dart';
// import 'package:todo_app_appwrite/shared.dart';
//
// class Homepage extends StatefulWidget {
//   const Homepage({Key? key}) : super(key: key);
//
//   @override
//   State<Homepage> createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   int _selectedIndex = 0;
//   String _selectedPriority = 'all';
//
//   @override
//   Widget build(BuildContext context) {
//     TodoProvider todoProvider = Provider.of<TodoProvider>(context, listen: false);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Todos"),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               setState(() {
//                 _selectedPriority = value;
//                 todoProvider.readTodos(priority: _selectedPriority);
//               });
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem(value: 'all', child: Text("All")),
//               PopupMenuItem(value: 'high', child: Text("High Priority")),
//               PopupMenuItem(value: 'medium', child: Text("Medium Priority")),
//               PopupMenuItem(value: 'low', child: Text("Low Priority")),
//             ],
//             icon: Icon(Icons.filter_list),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: Column(
//           children: [
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.blue, Colors.indigo],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Column( // Changed Row to Column to place text below image
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundImage: const AssetImage('assets/images/user_avatar.png'),
//                     // backgroundImage: AssetImage("assets/user_avatar.png"), // Change to actual user avatar
//                   ),
//                   SizedBox(height: 10), // Added spacing
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Welcome,",
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         "${UserSavedData.getEmail}",
//                         style: TextStyle(color: Colors.white70, fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView( // Using ListView to prevent overflow
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.delete_forever, color: Colors.red),
//                     title: Text("Delete All Todos"),
//                     onTap: () {
//                       todoProvider.deleteAllTodos().then((_) {
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("All Todos Deleted")),
//                         );
//                       });
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.logout, color: Colors.blue),
//                     title: Text("Logout"),
//                     onTap: () {
//                       logoutUser().then(
//                             (_) => Navigator.pushReplacementNamed(context, '/'),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Divider(),
//             Padding(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 children: [
//                   Text(
//                     "Made by Abhishek Nagar with 💖",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.copyright, size: 16),
//                       SizedBox(width: 5),
//                       Text("All rights reserved 2025"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//
//
//
//
//       body: _selectedIndex == 0 ? showOngoingTodos() : showCompletedTodos(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (value) => setState(() {
//           _selectedIndex = value;
//         }),
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.list), label: "Todo List"),
//           BottomNavigationBarItem(icon: Icon(Icons.done), label: "Completed"),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/new');
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget showOngoingTodos() {
//     return Consumer<TodoProvider>(
//       builder: (context, provider, child) {
//         final filteredTodos = provider.allTodos.where((todo) {
//           if (_selectedPriority == 'all') return !todo.data['isDone'];
//           return !todo.data['isDone'] && todo.data['priority'] == _selectedPriority;
//         }).toList();
//
//         return provider.checkLoading
//             ? Center(child: CircularProgressIndicator())
//             : filteredTodos.isEmpty
//             ? Center(child: Text("No Todos"))
//             : ListView.builder(
//           itemCount: filteredTodos.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               onTap: () {
//                 Navigator.pushNamed(context, '/edit', arguments: filteredTodos[index]);
//               },
//               title: Text(filteredTodos[index].data['title']),
//               subtitle: Text(filteredTodos[index].data['description']),
//               leading: Checkbox(
//                 value: filteredTodos[index].data['isDone'] ?? false,
//                 onChanged: (value) {
//                   provider.markCompleted(filteredTodos[index].$id, value ?? false);
//                 },
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _priorityTag(filteredTodos[index].data['priority']),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       provider.deleteTodo(filteredTodos[index].$id);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget showCompletedTodos() {
//     return Consumer<TodoProvider>(
//       builder: (context, provider, child) {
//         final filteredTodos = provider.allTodos.where((todo) {
//           if (_selectedPriority == 'all') return todo.data['isDone'];
//           return todo.data['isDone'] && todo.data['priority'] == _selectedPriority;
//         }).toList();
//
//         return provider.checkLoading
//             ? Center(child: CircularProgressIndicator())
//             : filteredTodos.isEmpty
//             ? Center(child: Text("No Todos Completed"))
//             : ListView.builder(
//           itemCount: filteredTodos.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               leading: Checkbox(
//                 value: filteredTodos[index].data['isDone'] ?? false,
//                 onChanged: (value) {
//                   provider.markCompleted(filteredTodos[index].$id, value ?? false);
//                 },
//               ),
//               title: Text(filteredTodos[index].data['title']),
//               subtitle: Text(filteredTodos[index].data['description']),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _priorityTag(filteredTodos[index].data['priority']),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       provider.deleteTodo(filteredTodos[index].$id);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _priorityTag(String priority) {
//     Color color;
//     switch (priority) {
//       case 'high':
//         color = Colors.red;
//         break;
//       case 'medium':
//         color = Colors.orange;
//         break;
//       case 'low':
//         color = Colors.green;
//         break;
//       default:
//         color = Colors.grey;
//     }
//
//     return Container(
//       margin: EdgeInsets.only(right: 8),
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color),
//       ),
//       child: Text(
//         priority.toUpperCase(),
//         style: TextStyle(color: color, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_appwrite/auth.dart';
import 'package:todo_app_appwrite/controllers/todo_provider.dart';
import 'package:todo_app_appwrite/shared.dart';

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  String _selectedPriority = 'all';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Icons for task categories
  final Map<String, IconData> _categoryIcons = {
    'UI Design': Icons.palette,
    'Web Development': Icons.code,
    'Office Meeting': Icons.people,
    'Dashboard Design': Icons.lightbulb,
  };


  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider = Provider.of<TodoProvider>(context, listen: false);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark); // Set status bar icons to black



    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.grid_view_rounded, color: Colors.black54),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer(); // Use GlobalKey to open drawer
              },
            ),
          ),
        ),
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.black54),
                onPressed: () {
                  Fluttertoast.showToast(
                    msg: "Coming Soon!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16.0,
                  );
                },
              ),

            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/user_avatar.png'),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Welcome,",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${UserSavedData.getEmail}",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text("Delete All Todos"),
                    onTap: () {
                      todoProvider.deleteAllTodos().then((_) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: "All Todos Deleted",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.blue),
                    title: const Text("Logout"),
                    onTap: () {
                      logoutUser().then(
                            (_) => Navigator.pushReplacementNamed(context, '/'),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Text(
                    "Made by Abhishek Nagar with 💖",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.copyright, size: 16),
                      SizedBox(width: 5),
                      Text("All rights reserved 2025"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2980B9), Color(0xFF3498DB), Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Consumer<TodoProvider>(
                builder: (context, provider, child) {
                  final totalTasks = provider.allTodos.length;
                  final completedTasks = provider.allTodos.where((todo) => todo.data['isDone'] == true).length;
                  final progress = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's progress summary",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$totalTasks Tasks",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          // Team avatars
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: Stack(
                              children: [
                                for (int i = 0; i < min(3, totalTasks); i++)
                                  Positioned(
                                    left: i * 30.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 18,
                                        backgroundImage: AssetImage('assets/images/user_avatar.png'),
                                      ),
                                    ),
                                  ),
                                if (totalTasks > 0)
                                  Positioned(
                                    left: min(3, totalTasks) * 30.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.white, width: 2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        radius: 18,
                                        child: Icon(Icons.add, color: Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Progress text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Progress",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${progress.toInt()}%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Task header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Current Tasks",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Filter action
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Filter by Priority"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text("All"),
                                onTap: () {
                                  setState(() {
                                    _selectedPriority = 'all';
                                    todoProvider.readTodos(priority: _selectedPriority);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("High Priority"),
                                onTap: () {
                                  setState(() {
                                    _selectedPriority = 'high';
                                    todoProvider.readTodos(priority: _selectedPriority);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("Medium Priority"),
                                onTap: () {
                                  setState(() {
                                    _selectedPriority = 'medium';
                                    todoProvider.readTodos(priority: _selectedPriority);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("Low Priority"),
                                onTap: () {
                                  setState(() {
                                    _selectedPriority = 'low';
                                    todoProvider.readTodos(priority: _selectedPriority);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            // Tasks list
            _selectedIndex == 0 ? showOngoingTodos() : showCompletedTodos(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home_rounded, 0),
                const SizedBox(width: 40), // Space for FloatingActionButton
                _buildNavItem(Icons.done_all, 1),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(top: 40),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 2,
          onPressed: () {
            Navigator.pushNamed(context, '/new');
          },
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  Widget _buildNavItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.blue : Colors.grey,
        size: 28,
      ),
      onPressed: () => setState(() {
        _selectedIndex = index;
      }),
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
            ? const Center(child: CircularProgressIndicator())
            : filteredTodos.isEmpty
            ? const Center(child: Text("No Tasks"))
            : Column(
          children: filteredTodos.map((todo) {
            final title = (todo.data['title'] ?? '').isEmpty ? 'Untitled Task' : todo.data['title'];
            final description = (todo.data['description'] ?? '').isEmpty ? 'N/A' : todo.data['description'];
            final shortDescription = description.length > 8 ? '${description.substring(0, 8)}...' : description;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                onTap: () {
                  Navigator.pushNamed(context, '/edit', arguments: todo);
                },
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: getColorFromPriority(todo.data['priority']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _categoryIcons[title] ?? Icons.task_alt,
                    color: getColorFromPriority(todo.data['priority']),
                    size: 26,
                  ),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    shortDescription,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: todo.data['isDone'] ?? false,
                      onChanged: (value) {
                        provider.markCompleted(todo.$id, value ?? false);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.grey),
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit', arguments: todo);
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
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
            ? const Center(child: CircularProgressIndicator())
            : filteredTodos.isEmpty
            ? const Center(child: Text("No Completed Tasks"))
            : Column(
          children: filteredTodos.map((todo) {
            final title = (todo.data['title'] ?? '').isEmpty ? 'Untitled Todo' : todo.data['title'];
            final description = (todo.data['description'] ?? '').isEmpty ? 'N/A' : todo.data['description'];
            final shortDescription = description.length > 8 ? '${description.substring(0, 8)}...' : description;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                onTap: () {
                  Navigator.pushNamed(context, '/edit', arguments: todo);
                },
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: getColorFromPriority(todo.data['priority']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _categoryIcons[title] ?? Icons.task_alt,
                    color: getColorFromPriority(todo.data['priority']),
                    size: 26,
                  ),
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[600],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    shortDescription,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: todo.data['isDone'] ?? false,
                      onChanged: (value) {
                        provider.markCompleted(todo.$id, value ?? false);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        provider.deleteTodo(todo.$id);
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

// Helper function to get color based on priority
  Color getColorFromPriority(String? priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }



  String generateRandomTimeRange() {
    final List<String> timeRanges = [
      '09:00 AM - 11:00 AM',
      '11:30 AM - 12:30 PM',
      '02:00 PM - 03:00 PM',
      '03:30 PM - 05:00 PM',
    ];
    return timeRanges[DateTime.now().millisecond % timeRanges.length];
  }

  // Helper function for min without importing dart:math
  int min(int a, int b) {
    return a < b ? a : b;
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}
