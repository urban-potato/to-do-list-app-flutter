// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CreateTaskRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateTaskScreen(),
      );
    },
    TaskRoute.name: (routeData) {
      final args = routeData.argsAs<TaskRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TaskScreen(
          key: args.key,
          task: args.task,
          taskIndex: args.taskIndex,
          boxName: args.boxName,
        ),
      );
    },
    TasksListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TasksListScreen(),
      );
    },
  };
}

/// generated route for
/// [CreateTaskScreen]
class CreateTaskRoute extends PageRouteInfo<void> {
  const CreateTaskRoute({List<PageRouteInfo>? children})
      : super(
          CreateTaskRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateTaskRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TaskScreen]
class TaskRoute extends PageRouteInfo<TaskRouteArgs> {
  TaskRoute({
    Key? key,
    required Task task,
    required int taskIndex,
    required String boxName,
    List<PageRouteInfo>? children,
  }) : super(
          TaskRoute.name,
          args: TaskRouteArgs(
            key: key,
            task: task,
            taskIndex: taskIndex,
            boxName: boxName,
          ),
          initialChildren: children,
        );

  static const String name = 'TaskRoute';

  static const PageInfo<TaskRouteArgs> page = PageInfo<TaskRouteArgs>(name);
}

class TaskRouteArgs {
  const TaskRouteArgs({
    this.key,
    required this.task,
    required this.taskIndex,
    required this.boxName,
  });

  final Key? key;

  final Task task;

  final int taskIndex;

  final String boxName;

  @override
  String toString() {
    return 'TaskRouteArgs{key: $key, task: $task, taskIndex: $taskIndex, boxName: $boxName}';
  }
}

/// generated route for
/// [TasksListScreen]
class TasksListRoute extends PageRouteInfo<void> {
  const TasksListRoute({List<PageRouteInfo>? children})
      : super(
          TasksListRoute.name,
          initialChildren: children,
        );

  static const String name = 'TasksListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
