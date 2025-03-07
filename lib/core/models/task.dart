import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? content;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.content,
  });

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, content: $content}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String?,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, description, content];
}
