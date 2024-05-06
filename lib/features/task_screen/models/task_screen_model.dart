import 'package:flutter/material.dart';
import 'package:to_do_list_app/data/entity/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskScreenModel extends ChangeNotifier {
  Task task;

  var _taskName = '';
  var taskDetails = '';
  String? errorMessage;

  set taskName(String value) {
    if (errorMessage != null && value.trim().isNotEmpty) {
      errorMessage = null;
      notifyListeners();
    }

    _taskName = value;
  }

  TaskScreenModel({required this.task}) {
    _setup();
  }

  void _setup() {
    _taskName = task.name;
    taskDetails = task.details;

    notifyListeners();
  }

  Future<void> saveTask(BuildContext context) async {
    final taskName = _taskName.trim();

    if (taskName.isEmpty) {
      if (taskDetails != task.details) {
        task.details = taskDetails;
        await task.save();
        return;
      }

      errorMessage = AppLocalizations.of(context)!.enterTask;
      notifyListeners();
      return;
    }

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
