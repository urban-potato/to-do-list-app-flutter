import 'package:auto_route/auto_route.dart';
import 'package:to_do_list_app/features/to_dos_screen/view/to_dos_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ToDosRoute.page, path: '/to_dos_list', initial: true),
      ];
}
