import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_task/core/constants/colors.dart';
import 'package:gen_task/core/constants/spacing.dart';
import 'package:gen_task/presentation/bloc/tasks/task_bloc.dart';
import 'package:gen_task/presentation/bloc/tasks/task_event.dart';
import 'package:gen_task/presentation/bloc/tasks/task_state.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TaskCreateScreen extends StatelessWidget {
  const TaskCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String _generatedContent = 'Generated content will appear here...';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Generate New Task',
          style: TextStyle(
            color: AppColors.textBrand,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ResponsiveRowColumn(
            layout:
                ResponsiveBreakpoints.of(context).smallerThan(TABLET)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
            columnSpacing: AppSpacing.md,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.textSecondary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          children: [
                            Text(
                              "Task Details",
                              style: TextStyle(
                                fontSize: AppSpacing.lg,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: titleController,
                              decoration: InputDecoration(
                                labelText: "Title",
                                labelStyle: TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.textSecondary,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                labelText: "Description",
                                labelStyle: TextStyle(
                                  color: AppColors.textPrimary,
                                ),

                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.textSecondary,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.md),

                    Expanded(
                      child: BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, state) {
                          print('BlocBuilder state: $state');
                          return _buildTaskState(context, state);
                        },
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildCancelButton(context),
                        SizedBox(width: AppSpacing.lg),
                        _buildGenerateButton(
                          context,
                          titleController,
                          descriptionController,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildCancelButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      context.go('/list');
    },
    child: Text("Cancel", style: TextStyle(color: AppColors.error)),
  );
}

Widget _buildGenerateButton(
  BuildContext context,
  TextEditingController titleController,
  TextEditingController descriptionController,
) {
  return ElevatedButton(
    onPressed: () {
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();
      print(
        'Generate button pressed with title: $title, description: $description',
      );
      if (title.isNotEmpty && description.isNotEmpty) {
        context.read<TaskBloc>().add(
          AddTask(title: title, description: description),
        );
        Future.delayed(Duration(milliseconds: 500), () {
          context.go('/list');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
    ),
    child: Text('Generate', style: TextStyle(color: AppColors.textBrand)),
  );
}

Widget _buildTaskState(BuildContext context, TaskState state) {
  String content = '';
  Color textColor = AppColors.textPrimary;
  bool isCentered = false;
  if (state is TaskInitial) {
    content = 'Generated content will appear here...';
  } else if (state is TaskLoading) {
    content = 'Loading...';
    isCentered = true;
  } else if (state is TaskLoaded && state.tasks.isNotEmpty) {
    content = state.tasks.last.content as String;
  } else if (state is TaskError) {
    content = state.message;
    textColor = AppColors.error;
  } else {
    content = "No content to display";
  }

  double maxHeight = MediaQuery.of(context).size.height * .5;

  return Container(
    padding: EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.textSecondary, width: 1),
      borderRadius: BorderRadius.circular(12),
      color: AppColors.brandColor,
      boxShadow: [
        BoxShadow(
          color: AppColors.textPrimary.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment:
          isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "Generated Content",
          style: TextStyle(
            fontSize: AppSpacing.lg,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: AppSpacing.md),

        Expanded(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxHeight: maxHeight),
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textSecondary, width: 1),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.textSecondary,
              ),
              child: Text(
                content,
                style: TextStyle(fontSize: AppSpacing.md, color: textColor),
                textAlign: isCentered ? TextAlign.center : TextAlign.left,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
