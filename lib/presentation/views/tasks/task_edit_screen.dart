import 'package:flutter/material.dart';
import 'package:gen_task/core/constants/colors.dart';

class TaskEditScreen extends StatefulWidget {
  final String taskId;
  const TaskEditScreen({super.key, required this.taskId});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit",
          style: TextStyle(
            color: AppColors.textBrand,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
