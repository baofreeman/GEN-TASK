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
    on<EditTask>(_onEditTask);
    on<RegenerateTask>(_onRegenerateTask);
    _loadInitialTasks();
  }

  List<Task> _tasks = [];

  Future<void> _loadInitialTasks() async {
    emit(TaskLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final taskJson = prefs.getStringList('tasks') ?? [];
      _tasks = taskJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
      emit(TaskLoaded(List.from(_tasks)));
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    }
  }

  Future<void> _onEditTask(EditTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final index = _tasks.indexWhere((task) => task.id == event.editTask.id);
      if (index != -1) {
        _tasks[index] = event.editTask;
        await _saveTasks(_tasks);
        emit(TaskLoaded(List.from(_tasks)));
      } else {
        emit(TaskError("Task not found"));
      }
    } catch (e) {
      emit(TaskError('Faile to edit task $e'));
    }
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final pref = await SharedPreferences.getInstance();
      final taskJson = pref.getStringList('tasks') ?? [];
      _tasks = taskJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
      emit(TaskLoaded(List.from(_tasks)));
    } catch (e) {
      emit(TaskError('Failed to load task: ${e.toString()}'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
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

      _tasks.add(newTask);
      await _saveTasks(_tasks);
      emit(TaskLoaded(List.from(_tasks)));
    } catch (e) {
      emit(TaskError('Failed to generate task: ${e.toString()}'));
    }
  }

  Future<void> _onRegenerateTask(RegenerateTask event, Emitter emit) async {
    emit(TaskLoading());
    try {
      final index = _tasks.indexWhere((task) => task.id == event.taskId);
      if (index != -1) {
        final currentTask = _tasks[index];
        final editTask = Task(
          id: currentTask.id,
          title: event.title,
          description: event.description,
          content: await _generateWithOpenAI(event.title, event.description),
        );
        _tasks[index] = editTask;
        print('$_tasks');
        await _saveTasks(_tasks);
        emit(TaskLoaded(List.from(_tasks)));
      } else {
        emit(TaskError('Task not found'));
      }
    } catch (e) {
      emit(TaskError('Failed to regenerate task: $e'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter emit) async {
    emit(TaskLoading());
    try {
      _tasks.removeWhere((task) => task.id == event.id);
      await _saveTasks(_tasks);
      emit(TaskLoaded(_tasks));
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }

  Future<String?> _generateWithOpenAI(String title, String description) async {
    if (apiKey.isEmpty) {
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
              "content":
                  "Create task details with $title and $description Returns results that match the language of the title and description",
            },
          ],
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        final content = data['choices'][0]['message']['content'];
        return content;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList('tasks', tasksJson);
    } catch (e) {
      print('Error in _saveTasks: $e');
    }
  }
}
