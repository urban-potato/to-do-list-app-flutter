import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/entity/todo.dart';

class CreateToDoModel {
  var toDoName = '';
  var toDoDetails = '';

  void saveToDO(BuildContext context) async {
    if (toDoName.isEmpty) return;

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ToDoAdapter());
    }

    final toDoBox = await Hive.openBox<ToDo>(HiveKeys.todayToDosBox);

    DateTime now = DateTime.now();
    final toDO = ToDo(
      name: toDoName,
      details: toDoDetails,
      dateTime: DateTime(now.year, now.month, now.day),
    );

    await toDoBox.add(toDO);

    if (context.mounted) AutoRouter.of(context).maybePop();
  }
}

class CreateToDoModelProvider extends InheritedWidget {
  const CreateToDoModelProvider({
    super.key,
    required super.child,
    required this.model,
  });

  final CreateToDoModel model;

  static CreateToDoModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CreateToDoModelProvider>();
  }

  static CreateToDoModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<CreateToDoModelProvider>()
        ?.widget;
    return widget is CreateToDoModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(CreateToDoModelProvider oldWidget) {
    return true;
  }
}
