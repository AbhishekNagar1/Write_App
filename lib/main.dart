import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_appwrite/VIEWS/add_new_todo.dart';
import 'package:todo_app_appwrite/VIEWS/checkUserAuthenticated.dart';
import 'package:todo_app_appwrite/VIEWS/edit_todo.dart';
import 'package:todo_app_appwrite/VIEWS/login.dart';
import 'package:todo_app_appwrite/VIEWS/signup.dart';
import 'package:todo_app_appwrite/auth.dart';
import 'package:todo_app_appwrite/controllers/todo_provider.dart';
import 'package:todo_app_appwrite/homepage.dart';
import 'package:todo_app_appwrite/shared.dart';
import 'package:todo_app_appwrite/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UserSavedData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => TodoProvider()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Write',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => FirstScreen(),
          '/home': (context) => Homepage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/new': (context) => NewTodo(),
          '/edit': (context) => EditTodo()
        },
      ),
    );
      // home: const Homepage());
  }
}