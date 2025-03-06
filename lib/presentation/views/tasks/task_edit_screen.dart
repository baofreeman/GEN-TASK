import 'package:flutter/material.dart';

class TaskEditScreen extends StatefulWidget {
  final String taskId;
  const TaskEditScreen({super.key, required this.taskId});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
