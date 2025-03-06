abstract class TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  final String description;
  AddTask({required this.title, required this.description});
}
