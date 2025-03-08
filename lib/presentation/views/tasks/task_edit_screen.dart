import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_task/core/constants/colors.dart';
import 'package:gen_task/core/constants/spacing.dart';
import 'package:gen_task/core/models/task.dart';
import 'package:gen_task/presentation/bloc/tasks/task_bloc.dart';
import 'package:gen_task/presentation/bloc/tasks/task_event.dart';
import 'package:gen_task/presentation/bloc/tasks/task_state.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TaskEditScreen extends StatefulWidget {
  final String taskId;
  const TaskEditScreen({super.key, required this.taskId});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _contentController = TextEditingController();
  }

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
        elevation: 0,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is TaskLoaded) {
            final task = state.tasks.firstWhere(
              (task) => task.id == widget.taskId,
              orElse: () => throw Exception('Task not found'),
            );
            if (_titleController.text != task.title ||
                _descriptionController.text != task.description ||
                _contentController.text != (task.content ?? '')) {
              _titleController.text = task.title;
              _descriptionController.text = task.description;
              _contentController.text = task.content ?? '';
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: ResponsiveRowColumn(
                  layout:
                      ResponsiveBreakpoints.of(context).smallerThan(TABLET)
                          ? ResponsiveRowColumnType.ROW
                          : ResponsiveRowColumnType.COLUMN,
                  rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                  columnSpacing: AppSpacing.md,
                  rowSpacing: AppSpacing.md,
                  children: [
                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Task Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                              TextField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  labelStyle: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.textSecondary,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.textPrimary,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                              TextField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  labelStyle: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.textSecondary,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.textPrimary,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ResponsiveRowColumnItem(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            children: [
                              Text(
                                'Content',
                                style: TextStyle(
                                  fontSize: AppSpacing.lg,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * .25,
                                ),
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(AppSpacing.md),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.textSecondary,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.brandColor.withOpacity(
                                        .01,
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _contentController,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ResponsiveRowColumnItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              final taskBloc = context.read<TaskBloc>();
                              taskBloc.add(
                                RegenerateTask(
                                  taskId: widget.taskId,
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Regenerate',
                              style: TextStyle(
                                fontSize: AppSpacing.md,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBrand,
                              ),
                            ),
                          ),

                          SizedBox(width: AppSpacing.md),

                          ElevatedButton(
                            onPressed: () {
                              final taskBloc = context.read<TaskBloc>();
                              final editTask = Task(
                                id: widget.taskId,
                                title: _titleController.text,
                                description: _descriptionController.text,
                                content:
                                    _contentController.text.isNotEmpty
                                        ? _contentController.text
                                        : null,
                              );
                              taskBloc.add(EditTask(editTask: editTask));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Task updated successfully!'),
                                ),
                              );
                              context.go('/list');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                fontSize: AppSpacing.md,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBrand,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Text('No content to display');
        },
      ),
    );
  }
}
