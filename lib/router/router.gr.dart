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
    ToDosRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ToDosScreen(),
      );
    }
  };
}

/// generated route for
/// [ToDosScreen]
class ToDosRoute extends PageRouteInfo<void> {
  const ToDosRoute({List<PageRouteInfo>? children})
      : super(
          ToDosRoute.name,
          initialChildren: children,
        );

  static const String name = 'ToDosRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
