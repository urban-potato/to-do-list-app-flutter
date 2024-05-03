import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/router/router.dart';
import 'package:to_do_list_app/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToDoListApp extends StatefulWidget {
  const ToDoListApp({super.key});

  @override
  State<ToDoListApp> createState() => _ToDoListAppState();

  static void setLocale(BuildContext context, String newLocale) {
    _ToDoListAppState? state =
        context.findAncestorStateOfType<_ToDoListAppState>();
    state?.setLocale(newLocale);
  }

  static String? getLocale(BuildContext context) =>
      context.findAncestorStateOfType<_ToDoListAppState>()?.locale;
}

class _ToDoListAppState extends State<ToDoListApp> {
  final _appRouter = AppRouter();
  var _locale = LocalesKeys.english;

  void setLocale(String value) {
    setState(() {
      _locale = value;
    });
  }

  String get locale => _locale;

  @override
  void initState() {
    super.initState();

    final sharedPreferences = GetIt.I<SharedPreferences>();
    final userLocale =
        sharedPreferences.getString(SharedPreferencesKeys.locale);

    if (userLocale != null) {
      setLocale(userLocale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'To-do list app',
      theme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(_locale),
      routerConfig: _appRouter.config(
        navigatorObservers: () => [TalkerRouteObserver(GetIt.I<Talker>())],
      ),
    );
  }
}
