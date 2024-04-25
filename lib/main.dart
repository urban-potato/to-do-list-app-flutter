import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:to_do_list_app/to_do_list_app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    GoogleFonts.config.allowRuntimeFetching = false;

    final sharedPreferences = await SharedPreferences.getInstance();
    GetIt.I.registerSingleton(sharedPreferences);

    final talker = TalkerFlutter.init();

    GetIt.I.registerSingleton(talker);
    GetIt.I<Talker>().debug('Talker started...');

    FlutterError.onError =
        (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

    runApp(const ToDoListApp());
  }, (error, stack) {
    GetIt.I<Talker>().handle(error, stack);
  });
}
