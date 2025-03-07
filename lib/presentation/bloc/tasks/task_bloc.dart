import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen_task/core/utils/helper.dart';
import 'package:http/http.dart' as http;
import 'package:gen_task/core/models/task.dart';
import 'package:gen_task/presentation/bloc/tasks/task_event.dart';
import 'package:gen_task/presentation/bloc/tasks/task_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<LoadTasks>(_onLoadTasks);
    on<DeleteTask>(_onDeleteTask);
    _loadSaveTasks();
  }
  final List<Task> _tasks = [];

  // Future<void> _loadSaveTasks() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final tasksJson = prefs.getStringList('tasks');
  //   if(tasksJson != null) {
  //     _tasks.addAll(tasksJson.map((json) => Task.fromJson(jsonDecode(json))));
  //     emit(TasksLoaded(List.from(_tasks)));
  //   }
  // }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await Future.delayed(Duration(milliseconds: 500));
      emit(TaskLoaded(List.from(_tasks)));
    } catch (e) {
      print('Error in _onLoadedTasks: $e');
      emit(TaskError('Failed to load task: ${e.toString()}'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    print('Emitting TaskLoaded with tasks: $_tasks');
    emit(TaskLoading());
    try {
      final generatedDesc = await _generateWithOpenAI(
        event.title,
        event.description,
      );

      final newTask = Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: event.title,
        description: event.description,
        content: generatedDesc,
      );

      print('New task created: $newTask');
      _tasks.add(newTask);
      await _saveTasks();
      print('Tasks after add: $_tasks');
      emit(TaskLoaded(List.from(_tasks)));
      print('Emitting TaskLoaded with tasks: $_tasks');
    } catch (e) {
      print('Error in _onAddTask: $e');
      emit(TaskError('Failed to generate task: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter emit) async {
    emit(TaskLoading());
    try {
      _tasks.removeWhere((task) => task.id == event.id);
      await _saveTasks();
      emit(TaskLoaded(_tasks));
    } catch (e) {
      print("Cannot delete task $e");
      emit(TaskError('Failed to delete task: $e'));
    }
  }

  Future<String?> _generateWithOpenAI(String title, String description) async {
    if (apiKey.isEmpty) {
      print('API Key is missing or empty');
      return null;
    }
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
          'max_tokens': 200,
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
        final content = data['choices'][0]['message']['content'] as String?;
        print('Generated content: $content');
        return content;
      } else {
        print('Failed to call OpenAI API: ${res.statusCode} - ${res.body}');
        return null;
      }
    } catch (e) {
      print('Error calling OpenAI API: $e');
      return null;
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson =
          _tasks.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList('tasks', tasksJson);
    } catch (e) {
      print('Error in _saveTasks: $e');
    }
  }

  Future<void> _loadSaveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskJson = prefs.getStringList('tasks');
    if (taskJson != null) {
      try {
        _tasks.clear();
        _tasks.addAll(taskJson.map((json) => Task.fromJson(jsonDecode(json))));
        emit(TaskLoaded(List.from(_tasks)));
      } catch (e) {
        emit(TaskError('Failed to load task $e'));
      }
    }
  }
}
