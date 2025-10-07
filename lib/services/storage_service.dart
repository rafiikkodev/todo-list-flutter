import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template_project_flutter/models/todo.dart';

class StorageService {
  static const String _todoKey = 'todos';

  // Get all todos
  Future<List<Todo>> getTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? todosJson = prefs.getString(_todoKey);

      if (todosJson == null || todosJson.isEmpty) {
        return [];
      }

      final List<dynamic> todosList = json.decode(todosJson);
      return todosList.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error getting todos: $e');
      return [];
    }
  }

  // Save all todos
  Future<bool> saveTodos(List<Todo> todos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String todosJson = json.encode(
        todos.map((todo) => todo.toJson()).toList(),
      );
      return await prefs.setString(_todoKey, todosJson);
    } catch (e) {
      debugPrint('Error saving todos: $e');
      return false;
    }
  }

  // Add new todo
  Future<bool> addTodo(Todo todo) async {
    try {
      final todos = await getTodos();
      todos.add(todo);
      return await saveTodos(todos);
    } catch (e) {
      debugPrint('Error adding todo: $e');
      return false;
    }
  }

  // Update todo
  Future<bool> updateTodo(Todo updatedTodo) async {
    try {
      final todos = await getTodos();
      final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);

      if (index != -1) {
        todos[index] = updatedTodo;
        return await saveTodos(todos);
      }
      return false;
    } catch (e) {
      debugPrint('Error updating todo: $e');
      return false;
    }
  }

  // Delete todo
  Future<bool> deleteTodo(String id) async {
    try {
      final todos = await getTodos();
      todos.removeWhere((todo) => todo.id == id);
      return await saveTodos(todos);
    } catch (e) {
      debugPrint('Error deleting todo: $e');
      return false;
    }
  }

  // Toggle todo completion
  Future<bool> toggleTodoCompletion(String id) async {
    try {
      final todos = await getTodos();
      final index = todos.indexWhere((todo) => todo.id == id);

      if (index != -1) {
        todos[index] = todos[index].copyWith(
          isCompleted: !todos[index].isCompleted,
        );
        return await saveTodos(todos);
      }
      return false;
    } catch (e) {
      debugPrint('Error toggling todo: $e');
      return false;
    }
  }

  // Get todos by date
  Future<List<Todo>> getTodosByDate(DateTime date) async {
    try {
      final todos = await getTodos();
      return todos.where((todo) {
        return todo.date.year == date.year &&
            todo.date.month == date.month &&
            todo.date.day == date.day;
      }).toList();
    } catch (e) {
      debugPrint('Error getting todos by date: $e');
      return [];
    }
  }

  // Get today's todos
  Future<List<Todo>> getTodayTodos() async {
    final now = DateTime.now();
    return await getTodosByDate(now);
  }

  // Clear all todos
  Future<bool> clearAllTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_todoKey);
    } catch (e) {
      debugPrint('Error clearing todos: $e');
      return false;
    }
  }
}
