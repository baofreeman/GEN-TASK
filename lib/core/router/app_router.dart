import 'package:gen_task/presentation/views/tasks/task_create_screen.dart';
import 'package:gen_task/presentation/views/tasks/task_edit_screen.dart';
import 'package:gen_task/presentation/views/tasks/task_list_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: '/', builder: (context, state) => TaskCreateScreen()),
      GoRoute(path: '/list', builder: (context, state) => TaskListScreen()),
      GoRoute(
        path: '/edit/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskEditScreen(taskId: id);
        },
      ),
    ],
  );
}
