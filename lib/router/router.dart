import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/entity/todo.dart';
import 'package:to_do_list_app/features/create_todo_screen/index.dart';
import 'package:to_do_list_app/features/todo_list_screen/index.dart';
import 'package:to_do_list_app/features/todo_screen/view/index.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ToDoListRoute.page, path: '/todo_list', initial: true),
        AutoRoute(page: CreateToDoRoute.page, path: '/todo_list/create'),
        AutoRoute(page: ToDoRoute.page, path: '/todo'),
      ];
}
