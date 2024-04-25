import 'package:auto_route/auto_route.dart';
import 'package:to_do_list_app/features/home_screen/index.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/', initial: true),
      ];
}
