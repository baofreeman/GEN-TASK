abstract class TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  final String description;
  AddTask({required this.title, required this.description});
}

class LoadTasks extends TaskEvent {}

class DeleteTask extends TaskEvent {
  final String id;
  DeleteTask(this.id);

  List<Object?> get props => [id];

  @override
  String toString() => 'DeleteTask(id: $id)';
}
