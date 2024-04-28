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
