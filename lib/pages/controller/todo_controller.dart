import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/models/todo_model.dart';
import 'package:flutterfirebaseapp/service/firestore_service.dart';

import 'loading_provider.dart';

class TodoController extends ChangeNotifier {
  final FirestoreService dbService;
  final LoadingProvider loadingProvider;

  TodoController({required this.dbService, required this.loadingProvider}) {
    getAllTodos();
  }

  var todos = <TodoModel>[];

  int get numberTodosCompleted {
    return todos.where((task) => task.completed).toList().length;
  }

  Future<void> getAllTodos() async {
    final data = await dbService.getTodos();
    todos = List.from(data);
    notifyListeners();
  }

  Future<void> addTodos(TodoModel todoModel) async {
    loadingProvider.setLoading(true);
    await dbService.addTodo(todoModel);
    notifyListeners();
    loadingProvider.setLoading(false);
    getAllTodos();
  }

  Future<void> updateTodo(String id, bool value) async {
    int index = todos.indexWhere((task) => task.id == id);

    if (index != -1) {
      TodoModel todo = todos[index].copyWith(completed: value);
      todos[index] = todo;

      await dbService.updateTodo(id);

      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    int index = todos.indexWhere((task) => task.id == id);

    if (index != -1) {
      todos.removeAt(index);

      await dbService.deleteTodo(id);

      notifyListeners();
    }
    await dbService.deleteTodo(id);
    notifyListeners();
  }

  Future<void> deleteAllTodos() async {
    todos.clear();
    await dbService.deleteAllData();
    notifyListeners();
  }
}
