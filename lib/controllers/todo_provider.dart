import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app_appwrite/auth.dart';
import 'package:todo_app_appwrite/shared.dart';

class TodoProvider extends ChangeNotifier {
  TodoProvider() {
    readTodos();
  }

  final String databaseId = "648dd8c248189329a1ec";
  final String collectionId = "648dd8ceef572e20c875";
  final Databases database = Databases(client);

  List<Document> _todos = [];
  List<Document> get allTodos => _todos;

  bool _isLoading = false;
  bool get checkLoading => _isLoading;

  Future<void> readTodos({String priority = 'all'}) async {
    _isLoading = true;
    notifyListeners();

    final email = UserSavedData.getEmail;
    try {
      List<String> queries = [Query.equal('createdBy', email)];
      if (priority != 'all') {
        queries.add(Query.equal('priority', priority));
      }

      final data = await database.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
        queries: queries,
      );

      _todos = data.documents;
    } catch (e) {
      print("Error reading todos: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createNewTodo(String title, String description, String priority) async {
    final email = UserSavedData.getEmail;
    try {
      await database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: {
          "title": title,
          "description": description,
          "isDone": false,
          "priority": priority,
          'createdBy': email
        },
      );
      readTodos();
    } catch (e) {
      print("Error creating todo: $e");
    }
  }

  Future<void> markCompleted(String id, bool isDone) async {
    try {
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
        data: {"isDone": isDone},
      );
      readTodos();
    } catch (e) {
      print("Error marking todo as completed: $e");
    }
  }

  Future<void> updateTodo(String id, String title, String desc, String priority) async {
    try {
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
        data: {"title": title, "description": desc, "priority": priority},
      );
      readTodos();
    } catch (e) {
      print("Error updating todo: $e");
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await database.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
      );
      readTodos();
    } catch (e) {
      print("Error deleting todo: $e");
    }
  }

  int getCompletedLength() {
    return _todos.where((todo) => todo.data['isDone'] == true).length;
  }

  Future<void> deleteAllTodos() async {
    for (var todo in _todos) {
      try {
        await database.deleteDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: todo.$id,
        );
      } catch (e) {
        print("Error deleting all todos: $e");
      }
    }
    readTodos();
  }
}
