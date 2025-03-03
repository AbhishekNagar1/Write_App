import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app_appwrite/auth.dart';
import 'package:todo_app_appwrite/shared.dart';

class TodoProvider extends ChangeNotifier {
  TodoProvider() {
    readTodos();
  }

  String databaseId = "648dd8c248189329a1ec";
  String collectionId = "648dd8ceef572e20c875";
  final Databases database = Databases(client);

  List<Document> _todos = [];
  List<Document> get allTodos => _todos;

  bool _isLoading = false;
  bool get checkLoading => _isLoading;

  Future readTodos({String priority = 'all'}) async {
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
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future createNewTodo(String title, String description, String priority) async {
    final email = UserSavedData.getEmail;
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
  }

  Future markCompleted(String id, bool isDone) async {
    await database.updateDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: id,
      data: {"isDone": isDone},
    );

    readTodos();
  }

  Future updateTodo(String id, String title, String desc, String priority) async {
    await database.updateDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: id,
      data: {"title": title, "description": desc, "priority": priority},
    );

    readTodos();
  }

  Future deleteTodo(String id) async {
    await database.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id
    );

    readTodos();
  }

  int getCompletedLength() {
    return _todos.where((todo) => todo.data['isDone'] == true).length;
  }

  Future deleteAllTodos() async {
    for (var todo in _todos) {
      await database.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: todo.$id,
      );
    }
    readTodos();
  }
}
