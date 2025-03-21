import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gen_task/core/constants/colors.dart';
import 'package:gen_task/core/constants/spacing.dart';
import 'package:gen_task/presentation/bloc/tasks/task_bloc.dart';
import 'package:gen_task/presentation/bloc/tasks/task_event.dart';
import 'package:gen_task/presentation/bloc/tasks/task_state.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            rowMainAxisAlignment: MainAxisAlignment.start,
            columnMainAxisAlignment: MainAxisAlignment.start,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            columnSpacing: AppSpacing.md,
            rowSpacing: AppSpacing.md,
            children: [
              // Task input
              ResponsiveRowColumnItem(
                columnOrder: 1,
                child: SizedBox(
                  width: 400,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: "Title",
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
                                  color: AppColors.primaryColor,
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
                            controller: descriptionController,
                            decoration: InputDecoration(
                              labelText: "Description",
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
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
                          Row(
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // generated content
              ResponsiveRowColumnItem(
                columnOrder: 2,
                child: Expanded(
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
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
                          ResponsiveBreakpoints.of(context).smallerThan(TABLET)
                              ? Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.25,
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
                                      return _buildTaskState(context, state);
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
                                        return _buildTaskState(context, state);
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Create task successfully!')));
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
    content = state.tasks.last.content.toString();
  } else if (state is TaskError) {
    content = state.message;
    textColor = AppColors.error;
  } else {
    content = content;
  }

  // return Text(
  //   content,
  //   style: TextStyle(fontSize: AppSpacing.md, color: textColor),
  //   textAlign: isCentered ? TextAlign.center : TextAlign.left,
  // );

  return MarkdownBody(
    data: content,
    styleSheet: MarkdownStyleSheet(
      textAlign: isCentered ? WrapAlignment.center : WrapAlignment.start,
      p: TextStyle(color: textColor, fontSize: 14),
      strong: TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}
