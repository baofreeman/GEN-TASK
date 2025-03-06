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

    return BlocProvider(
      create: (context) => TaskBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Generate New Task',
            style: TextStyle(color: AppColors.textBrand),
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        body: SafeArea(
          child: Center(
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
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.textSecondary,
                                      ),
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
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: AppSpacing.md),

                        ResponsiveRowColumnItem(
                          child: BlocBuilder<TaskBloc, TaskState>(
                            builder: (context, state) {
                              if (state is TaskLoading) {
                                return Center(
                                  child: Text(
                                    "Loading...",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                );
                              } else if (state is TaskLoaded &&
                                  state.tasks.isNotEmpty) {
                                // final latestTask = state.tasks.last;
                                return Container(
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
                                          "Generated Content",
                                          style: TextStyle(
                                            fontSize: AppSpacing.lg,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.textSecondary,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text('data'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (state is TaskError) {
                                return Container(
                                  padding: EdgeInsets.all(AppSpacing.md),
                                  margin: EdgeInsets.only(top: AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.brandColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Error: ${state.message}',
                                    style: TextStyle(color: AppColors.error),
                                  ),
                                );
                              }
                              return Container();
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
        ),
      ),
    );
  }
}

Widget _buildCancelButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      context.go('/');
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
      if (title.isNotEmpty && description.isNotEmpty) {
        context.read<TaskBloc>().add(
          AddTask(title: title, description: description),
        );
        context.go('/');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
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
