import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/data/entity/task.dart';

class TaskScreenModel extends ChangeNotifier {
  final int taskIndex;
  final String boxName;

  Task? _task;
  Task? get task => _task;

  late String taskName;
  late String taskDetails;

  TaskScreenModel({
    required this.taskIndex,
    required this.boxName,
  }) {
    _setup();
  }

  void saveTask() async {
    if (taskName.isEmpty) return;
    if (taskName == _task?.name && taskDetails == _task?.details) return;

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }

    final box = await Hive.openBox<Task>(boxName);

    _task?.name = taskName;
    _task?.details = taskDetails;

    if (_task != null) {
      await box.putAt(taskIndex, _task!);
    }
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }

    final box = await Hive.openBox<Task>(boxName);

    _task = box.getAt(taskIndex);

    taskName = _task?.name ?? '';
    taskDetails = _task?.details ?? '';

    notifyListeners();
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
