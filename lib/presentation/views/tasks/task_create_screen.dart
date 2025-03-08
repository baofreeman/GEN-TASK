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
                            labelStyle: TextStyle(color: AppColors.textPrimary),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
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
                            labelStyle: TextStyle(color: AppColors.textPrimary),

                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
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
              ),

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
                      children: [
                        Text(
                          'Generated Content',
                          style: TextStyle(
                            fontSize: AppSpacing.lg,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * .25,
                          ),
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.textSecondary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.brandColor.withOpacity(.1),
                          ),
                          child: SingleChildScrollView(
                            child: BlocBuilder<TaskBloc, TaskState>(
                              builder: (context, state) {
                                return _buildTaskState(context, state);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ResponsiveRowColumnItem(
                child: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCancelButton(context),

                      SizedBox(width: AppSpacing.md),

                      _buildGenerateButton(
                        context,
                        titleController,
                        descriptionController,
                      ),
                    ],
                  ),
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
    style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 23, 146, 35),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
    ),
    child: Text(
      'List',
      style: TextStyle(
        color: AppColors.textBrand,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
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
        // Future.delayed(Duration(milliseconds: 500), () {
        //   context.go('/list');
        // });
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
        vertical: AppSpacing.md,
      ),
    ),
    child: Text(
      'Generate',
      style: TextStyle(
        color: AppColors.textBrand,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget _buildTaskState(BuildContext context, TaskState state) {
  String content = 'Generated content will appear here...';
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

  return Text(
    content,
    style: TextStyle(fontSize: AppSpacing.md, color: textColor),
    textAlign: isCentered ? TextAlign.center : TextAlign.left,
  );
}
