import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app_appwrite/auth.dart';
import 'package:todo_app_appwrite/shared.dart';

class TodoProvider extends ChangeNotifier{
  TodoProvider(){
    readTodos();
  }

  String databaseId = "648dd8c248189329a1ec";
  String collectionId = "648dd8ceef572e20c875";

  final Databases database = Databases(client);

  List<Document> _todos = [];

  List<Document> get allTodos => _todos;
  bool _isLoading = false;
  bool get checkLoading => _isLoading;

  Future readTodos() async{
    _isLoading=true;
    notifyListeners();
    final email = UserSavedData.getEmail;
    try{
      final data=await database.listDocuments(databaseId: databaseId, collectionId: collectionId,
      queries: [
        Query.equal('createdBy', email),
      ]);
      _todos=data.documents;
      _isLoading=false;
      notifyListeners();
    } catch(e) {
      _isLoading=false;
      notifyListeners();
      print(e);
    }
  }

  // Create a new Todo

  Future createNewTodo(String? title, String? description) async {
    final email=UserSavedData.getEmail;
    final collection = await database.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: {
          "title": title,
          "description": description,
          "isDone": false,
          'createdBy': email
        });
    print("new todo created");
    readTodos();
    notifyListeners();
  }

// change the todo to completed or vise versa
  Future markCompleted(String id, bool isDone) async {
    final data = await database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
        data: {"isDone": isDone});

    print("modified document");

    readTodos();
    notifyListeners();
  }

  // update the whole todo

  Future updateTodo(String title, String desc, String id) async {
    final data = await database.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: id,
        data: {"title": title, "description": desc});

    print("todo modified");

    readTodos();
    notifyListeners();
  }

  // delete a todo

  Future deleteTodo(String id) async {
    final data = await database.deleteDocument(
        databaseId: databaseId, collectionId: collectionId, documentId: id);

    readTodos();
    notifyListeners();
  }

  // get the length of all the todos that are completed

  int getCompletedLength() {
    int count = 0;
    for (var i = 0; i < _todos.length; i++) {
      if (_todos[i].data['isDone'] == true) {
        count++;
      }
    }
    return count;
  }

  //delete all the todos by the user

  Future deleteAllTodos() async {
    for (var i = 0; i < _todos.length; i++) {
      await database.deleteDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: _todos[i].$id);
    }
    readTodos();
    notifyListeners();
  }

}