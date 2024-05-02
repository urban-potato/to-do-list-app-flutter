import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/features/create_task_screen/index.dart';
import 'package:to_do_list_app/features/tasks_list_screen/index.dart';
import 'package:to_do_list_app/features/task_screen/view/index.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            page: TasksListRoute.page, path: '/tasks_list', initial: true),
        AutoRoute(page: CreateTaskRoute.page, path: '/tasks_list/create'),
        AutoRoute(page: TaskRoute.page, path: '/task'),
      ];
}
