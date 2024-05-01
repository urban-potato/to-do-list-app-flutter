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
    CreateToDoRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CreateToDoScreen(),
      );
    },
    ToDoListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ToDoListScreen(),
      );
    },
    ToDoRoute.name: (routeData) {
      final args = routeData.argsAs<ToDoRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ToDoScreen(
          key: args.key,
          toDoIndex: args.toDoIndex,
          boxName: args.boxName,
        ),
      );
    },
  };
}

/// generated route for
/// [CreateToDoScreen]
class CreateToDoRoute extends PageRouteInfo<void> {
  const CreateToDoRoute({List<PageRouteInfo>? children})
      : super(
          CreateToDoRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateToDoRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ToDoListScreen]
class ToDoListRoute extends PageRouteInfo<void> {
  const ToDoListRoute({List<PageRouteInfo>? children})
      : super(
          ToDoListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ToDoListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ToDoScreen]
class ToDoRoute extends PageRouteInfo<ToDoRouteArgs> {
  ToDoRoute({
    Key? key,
    required int toDoIndex,
    required String boxName,
    List<PageRouteInfo>? children,
  }) : super(
          ToDoRoute.name,
          args: ToDoRouteArgs(
            key: key,
            toDoIndex: toDoIndex,
            boxName: boxName,
          ),
          initialChildren: children,
        );

  static const String name = 'ToDoRoute';

  static const PageInfo<ToDoRouteArgs> page = PageInfo<ToDoRouteArgs>(name);
}

class ToDoRouteArgs {
  const ToDoRouteArgs({
    this.key,
    required this.toDoIndex,
    required this.boxName,
  });

  final Key? key;

  final int toDoIndex;

  final String boxName;

  @override
  String toString() {
    return 'ToDoRouteArgs{key: $key, toDoIndex: $toDoIndex, boxName: $boxName}';
  }
}
