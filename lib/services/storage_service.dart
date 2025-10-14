import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template_project_flutter/models/todo.dart';

class StorageService {
  static const String _todoKey = 'todos';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<Todo>> getTodos() async {
    try {
      final prefs = await _preferences;
      final String? todosJson = prefs.getString(_todoKey);

      if (todosJson == null || todosJson.isEmpty) {
        return [];
      }

      final List<dynamic> todosList = json.decode(todosJson) as List<dynamic>;
      return todosList
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('Error getting todos: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<bool> saveTodos(List<Todo> todos) async {
    try {
      final prefs = await _preferences;

      final String todosJson = json.encode(
        todos.map((todo) => todo.toJson()).toList(),
      );

      return await prefs.setString(_todoKey, todosJson);
    } catch (e, stackTrace) {
      debugPrint('Error saving todos: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> addTodo(Todo todo) async {
    try {
      final todos = await getTodos();
      todos.add(todo);
      return await saveTodos(todos);
    } catch (e, stackTrace) {
      debugPrint('Error adding todo: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> updateTodo(Todo updatedTodo) async {
    try {
      final todos = await getTodos();
      final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);

      if (index == -1) {
        debugPrint('Todo with id ${updatedTodo.id} not found');
        return false;
      }

      todos[index] = updatedTodo;
      return await saveTodos(todos);
    } catch (e, stackTrace) {
      debugPrint('Error updating todo: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      final todos = await getTodos();
      final initialLength = todos.length;

      todos.removeWhere((todo) => todo.id == id);

      if (todos.length == initialLength) {
        debugPrint('Todo with id $id not found');
      }

      return await saveTodos(todos);
    } catch (e, stackTrace) {
      debugPrint('Error deleting todo: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> toggleTodoCompletion(String id) async {
    try {
      final todos = await getTodos();
      final index = todos.indexWhere((todo) => todo.id == id);

      if (index == -1) {
        debugPrint('Todo with id $id not found');
        return false;
      }

      todos[index] = todos[index].copyWith(
        isCompleted: !todos[index].isCompleted,
      );

      return await saveTodos(todos);
    } catch (e, stackTrace) {
      debugPrint('Error toggling todo: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<List<Todo>> getTodosByDate(DateTime date) async {
    try {
      final todos = await getTodos();

      return todos.where((todo) {
        return _isSameDate(todo.date, date);
      }).toList();
    } catch (e, stackTrace) {
      debugPrint('Error getting todos by date: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<List<Todo>> getTodayTodos() async {
    final now = DateTime.now();
    return await getTodosByDate(now);
  }

  Future<List<Todo>> getCompletedTodos() async {
    try {
      final todos = await getTodos();
      return todos.where((todo) => todo.isCompleted).toList();
    } catch (e, stackTrace) {
      debugPrint('Error getting completed todos: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<List<Todo>> getIncompleteTodos() async {
    try {
      final todos = await getTodos();
      return todos.where((todo) => !todo.isCompleted).toList();
    } catch (e, stackTrace) {
      debugPrint('Error getting incomplete todos: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<bool> clearAllTodos() async {
    try {
      final prefs = await _preferences;
      return await prefs.remove(_todoKey);
    } catch (e, stackTrace) {
      debugPrint('Error clearing todos: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
