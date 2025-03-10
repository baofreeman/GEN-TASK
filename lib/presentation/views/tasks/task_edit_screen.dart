import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
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
                          ? ResponsiveRowColumnType.COLUMN
                          : ResponsiveRowColumnType.ROW,
                  rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                  columnMainAxisAlignment: MainAxisAlignment.start,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  columnSpacing: AppSpacing.md,
                  rowSpacing: AppSpacing.md,
                  children: [
                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      columnOrder: 1,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'Title',
                                  labelStyle: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      columnOrder: 2,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                'Content',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: AppSpacing.md),
                              ResponsiveBreakpoints.of(
                                    context,
                                  ).smallerThan(TABLET)
                                  ? Container(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                          0.25,
                                    ),
                                    width: double.infinity,

                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.secondaryColor,
                                    ),
                                    child: SingleChildScrollView(
                                      child: BlocBuilder<TaskBloc, TaskState>(
                                        builder: (context, state) {
                                          return _buildTaskState(
                                            context,
                                            state,
                                            task,
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  : Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: AppColors.secondaryColor,
                                      ),
                                      child: SingleChildScrollView(
                                        child: BlocBuilder<TaskBloc, TaskState>(
                                          builder: (context, state) {
                                            return _buildTaskState(
                                              context,
                                              state,
                                              task,
                                            );
                                          },
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
                      rowFlex: 1,
                      columnOrder: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              final taskBloc = context.read<TaskBloc>();
                              final title = _titleController.text.trim();
                              final description =
                                  _descriptionController.text.trim();
                              final content = _contentController.text.trim();

                              if (title.isNotEmpty && description.isNotEmpty) {
                                taskBloc.add(
                                  RegenerateTask(
                                    taskId: widget.taskId,
                                    title: title,
                                    description: description,
                                    content: content,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Task regenerate successfully!',
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill in all fields'),
                                  ),
                                );
                              }
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
                              final title = _titleController.text.trim();
                              final description =
                                  _descriptionController.text.trim();
                              final content = task.content;

                              final editTask = Task(
                                id: widget.taskId,
                                title: title,
                                description: description,
                                content: content,
                              );

                              if (title.isNotEmpty && description.isNotEmpty) {
                                taskBloc.add(EditTask(editTask: editTask));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Task updated successfully!'),
                                  ),
                                );
                                context.go('/list');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill in all fields'),
                                  ),
                                );
                              }
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

Widget _buildTaskState(BuildContext context, TaskState state, Task task) {
  String content = 'Generated content will appear here...';
  Color textColor = AppColors.textPrimary;
  bool isCentered = false;

  if (state is TaskInitial) {
    content = 'Generated content will appear here...';
  } else if (state is TaskLoading) {
    content = 'Loading...';
    isCentered = true;
  } else if (state is TaskLoaded && state.tasks.isNotEmpty) {
    content = task.content.toString();
  } else if (state is TaskError) {
    content = state.message;
    textColor = AppColors.error;
  } else {
    content = content;
  }

  return MarkdownBody(
    data: content,
    styleSheet: MarkdownStyleSheet(
      textAlign: isCentered ? WrapAlignment.center : WrapAlignment.start,
      p: TextStyle(color: textColor, fontSize: 14),
      strong: TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}
