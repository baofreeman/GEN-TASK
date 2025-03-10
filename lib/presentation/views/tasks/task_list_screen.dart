import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_task/core/constants/colors.dart';
import 'package:gen_task/core/constants/spacing.dart';
import 'package:gen_task/presentation/bloc/tasks/task_bloc.dart';
import 'package:gen_task/presentation/bloc/tasks/task_event.dart';
import 'package:gen_task/presentation/bloc/tasks/task_state.dart';
import 'package:go_router/go_router.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasks List",
          style: TextStyle(
            color: AppColors.textBrand,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 500), () {
                      context.go('/create');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: Text(
                    '+ Create New Task',
                    style: TextStyle(
                      color: AppColors.textBrand,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Expanded(
                child: BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    return _buildTaskState(context, state);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTaskState(BuildContext context, TaskState state) {
  if (state is TaskLoading) {
    return Center(child: CircularProgressIndicator());
  }
  if (state is TaskLoaded) {
    if (state.tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks available. Create one!',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.tasks.length,
      itemBuilder: (context, index) {
        final task = state.tasks[index];
        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            contentPadding: EdgeInsets.all(AppSpacing.sm),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                task.description,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                maxLines: 2,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go('/edit/${task.id}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Edit",
                    style: TextStyle(color: AppColors.textBrand, fontSize: 12),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  onPressed: () {
                    context.read<TaskBloc>().add(DeleteTask(task.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task deleted successfully!')),
                    );
                    print('Delete task: ${task.id}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Delete",
                    style: TextStyle(color: AppColors.textBrand, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  if (state is TaskError) {
    return Center(child: Text(state.message));
  }
  return Center(child: Text('No tasks available. Generate one!'));
}
