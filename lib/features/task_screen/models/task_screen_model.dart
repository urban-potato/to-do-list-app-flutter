import 'package:flutter/material.dart';
import 'package:to_do_list_app/data/entity/task.dart';

class TaskScreenModel extends ChangeNotifier {
  Task task;

  late String taskName;
  late String taskDetails;

  TaskScreenModel({required this.task}) {
    _setup();
  }

  void _setup() {
    taskName = task.name;
    taskDetails = task.details;

    notifyListeners();
  }

  Future<void> saveTask() async {
    if (taskName.isEmpty) return;
    if (taskName == task.name && taskDetails == task.details) return;

    task.name = taskName;
    task.details = taskDetails;

    await task.save();
  }
}

class TaskScreenModelProvider extends InheritedNotifier {
  const TaskScreenModelProvider(
      {super.key, required super.child, required this.model})
      : super(notifier: model);

  final TaskScreenModel model;

  static TaskScreenModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskScreenModelProvider>();
  }

  static TaskScreenModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskScreenModelProvider>()
        ?.widget;
    return widget is TaskScreenModelProvider ? widget : null;
  }
}
