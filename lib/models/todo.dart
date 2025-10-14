import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isCompleted = false,
  });

  // Convert Todo to JSON - simpan data ke storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': time,
      'isCompleted': isCompleted,
    };
  }

  // Create Todo from JSON - baca data dari storage
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Copy with method untuk update
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? time,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, description, date, time, isCompleted];
}
