import 'package:equatable/equatable.dart';
import 'package:gen_task/core/models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class AddTask extends TaskEvent {
  final String title;
  final String description;
  const AddTask({required this.title, required this.description});

  @override
  List<Object> get props => [title, description];
}

class LoadTasks extends TaskEvent {}

class DeleteTask extends TaskEvent {
  final String id;
  const DeleteTask(this.id);

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'DeleteTask(id: $id)';
}

class EditTask extends TaskEvent {
  final Task editTask;

  const EditTask({required this.editTask});

  @override
  List<Object?> get props => [editTask];
}

class RegenerateTask extends TaskEvent {
  final String taskId;
  final String title;
  final String description;

  const RegenerateTask({
    required this.taskId,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description, taskId];
}
