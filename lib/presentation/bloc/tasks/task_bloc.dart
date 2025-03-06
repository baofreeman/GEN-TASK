import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_task/core/utils/helper.dart';
import 'package:http/http.dart' as http;
import 'package:gen_task/core/models/task.dart';
import 'package:gen_task/presentation/bloc/tasks/task_event.dart';
import 'package:gen_task/presentation/bloc/tasks/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<AddTask>(_onAddTask);
  }
}

List<Task> _tasks = [];

void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
  emit(TaskLoading());
  try {
    final generatedDesc = await _generateWithOpenAI(
      event.title,
      event.description,
    );

    final newTask = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: event.title,
      description: generatedDesc ?? event.description,
    );

    _tasks.add(newTask);
    emit(TaskLoaded(_tasks));
  } catch (e) {
    emit(TaskError('Failed to generate task: ${e.toString()}'));
  }
}

Future<String?> _generateWithOpenAI(String title, String description) async {
  try {
    final res = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-4o",
        "temperature": 0,
        "messages": [
          {
            "role": "user",
            "content": "Create task details with $title and $description",
          },
        ],
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data["choices"][0]["message"]["content"]);
    } else {
      print('Failed to call OpenAI API: ${res.statusCode} - ${res.body}');
      return null;
    }
  } catch (e) {
    print('Error calling OpenAI API: $e');
    return null;
  }
}
