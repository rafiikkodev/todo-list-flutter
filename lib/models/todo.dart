import 'dart:convert';

class Todo {
  String id;
  String title;
  String? description;
  bool done;
  DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.done = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
    id: map['id'] as String,
    title: map['title'] as String,
    description: map['description'] as String?,
    done: map['done'] as bool? ?? false,
    createdAt: DateTime.parse(map['createdAt'] as String),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'done': done,
    'createdAt': createdAt.toIso8601String(),
  };

  String toJson() => jsonEncode(toMap());
  factory Todo.fromJson(String source) =>
      Todo.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
