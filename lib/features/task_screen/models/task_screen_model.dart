import 'package:flutter/material.dart';
import 'package:to_do_list_app/data/data_providers/hive_box_manager.dart';
import 'package:to_do_list_app/data/entities/task.dart';
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
    if (taskName == task.name && taskDetails == task.details) return;

    final boxBase = task.box;
    if (boxBase == null) return;

    final isBoxOpen = boxBase.isOpen;

    if (taskName.isEmpty) {
      if (context.mounted) {
        errorMessage = AppLocalizations.of(context)!.enterTask;
        notifyListeners();
      }

      if (taskDetails != task.details) {
        task.details = taskDetails;

        await _openBoxIfClosed(isBoxOpen, boxBase.name);
        await task.save();
        await _closeBoxIfWasOpenedManually(isBoxOpen, boxBase.name);
      }

      return;
    }

    task.name = taskName;
    task.details = taskDetails;

    await _openBoxIfClosed(isBoxOpen, boxBase.name);
    await task.save();
    await _closeBoxIfWasOpenedManually(isBoxOpen, boxBase.name);
  }

  Future<void> _openBoxIfClosed(bool isBoxOpen, String boxName) async {
    if (!isBoxOpen) {
      await HiveBoxManager.instance.openTaskBox(boxName);
    }
  }

  Future<void> _closeBoxIfWasOpenedManually(
      bool wasBoxOpen, String boxName) async {
    if (!wasBoxOpen) {
      await HiveBoxManager.instance.closeTaskBox(boxName);
    }
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
