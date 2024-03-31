import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? id;
  final String title;
  final bool completed;
  final DateTime createdAt;

  TodoModel({
    this.id,
    required this.title,
    this.completed = false,
    required this.createdAt,
  });

  // Construtor Factory para converter JSON em objeto Dart
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
      createdAt: DateTime.fromMicrosecondsSinceEpoch(
        (json['createdAt'] as Timestamp).microsecondsSinceEpoch,
      ),
    );
  }
  // Método para converter objeto Dart em um Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
      'createdAt': createdAt,
    };
  }

  TodoModel copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? createdAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
