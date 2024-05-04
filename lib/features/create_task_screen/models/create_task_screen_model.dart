import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/data/entity/task.dart';

class CreateTaskScreenModel {
  var taskName = '';
  var taskDetails = '';

  void saveTask(BuildContext context) async {
    if (taskName.isEmpty) return;

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }

    final box = await Hive.openBox<Task>(HiveKeys.todayTasksBox);

    DateTime now = DateTime.now();
    final task = Task(
      name: taskName,
      details: taskDetails,
      dateTime: DateTime(now.year, now.month, now.day),
    );

    await box.add(task);

    if (context.mounted) AutoRouter.of(context).maybePop();
  }
}

class CreateTaskScreenModelProvider extends InheritedWidget {
  const CreateTaskScreenModelProvider({
    super.key,
    required super.child,
    required this.model,
  });

  final CreateTaskScreenModel model;

  static CreateTaskScreenModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CreateTaskScreenModelProvider>();
  }

  static CreateTaskScreenModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
            CreateTaskScreenModelProvider>()
        ?.widget;
    return widget is CreateTaskScreenModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(CreateTaskScreenModelProvider oldWidget) {
    return false;
  }
}
