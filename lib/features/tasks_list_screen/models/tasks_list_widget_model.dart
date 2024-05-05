import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/data/data_provider/hive_box_manager.dart';
import 'package:to_do_list_app/data/entity/task.dart';

class TasksListWidgetModel extends ChangeNotifier {
  final String boxName;
  late final Box<Task> _box;
  ValueListenable<Box<Task>>? _listenableBox;

  int _tasksListLength = 0;
  int get tasksListLength => _tasksListLength;

  TasksListWidgetModel({required this.boxName}) {
    GetIt.I<Talker>().debug('($boxName) TasksListWidgetModel init');
  }

  Future<int> setupModel() async {
    GetIt.I<Talker>().debug('($boxName) TasksListWidgetModel _setup');

    _box = await HiveBoxManager.instance.openTaskBox(boxName);
    _getTasksNumberFromHive();

    _listenableBox = _box.listenable();
    _listenableBox?.addListener(_getTasksNumberFromHive);

    return 0;
  }

  @override
  Future<void> dispose() async {
    GetIt.I<Talker>().debug('($boxName) TasksListWidgetModel dispose');

    _listenableBox?.removeListener(_getTasksNumberFromHive);

    Future.delayed(Duration.zero, () async {
      await HiveBoxManager.instance.closeTaskBox(boxName);
    });

    super.dispose();
  }

  void _getTasksNumberFromHive() {
    _tasksListLength = _box.length;

    notifyListeners();
  }

  Task? getTaskFromHive(int taskIndex) {
    final task = _box.getAt(taskIndex);

    return task;
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }

  Future<void> moveTaskFromTodayToTomorrowOrViceVersa(Task task) async {
    String toBoxName;

    if (boxName == HiveKeys.todayTasksBox) {
      toBoxName = HiveKeys.otherTasksBox;
    } else {
      toBoxName = HiveKeys.todayTasksBox;
    }

    DateTime newTaskDateTime;

    if (boxName == HiveKeys.todayTasksBox) {
      newTaskDateTime = DateTime(
          task.dateTime.year, task.dateTime.month, task.dateTime.day + 1);
    } else {
      DateTime now = DateTime.now();
      newTaskDateTime = DateTime(now.year, now.month, now.day);
    }

    await task.delete();

    task.dateTime = newTaskDateTime;

    final toBox = await HiveBoxManager.instance.openTaskBox(toBoxName);
    await toBox.add(task);
    await HiveBoxManager.instance.closeTaskBox(toBoxName);
  }

  Future<void> completeOrUncompleteTask(Task task) async {
    String toBoxName;

    await task.delete();

    if (boxName != HiveKeys.doneTasksBox) {
      task.isDone = true;
      toBoxName = HiveKeys.doneTasksBox;
    } else {
      final now = DateTime.now();
      final todayDateTime = DateTime(now.year, now.month, now.day);

      task.isDone = false;
      task.dateTime = todayDateTime;
      toBoxName = HiveKeys.todayTasksBox;
    }

    final toBox = await HiveBoxManager.instance.openTaskBox(toBoxName);
    await toBox.add(task);
    await HiveBoxManager.instance.closeTaskBox(toBoxName);
  }
}

class TasksListWidgetModelProvider extends InheritedNotifier {
  const TasksListWidgetModelProvider({
    super.key,
    required super.child,
    required this.model,
  }) : super(notifier: model);

  final TasksListWidgetModel model;

  static TasksListWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksListWidgetModelProvider>();
  }

  static TasksListWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksListWidgetModelProvider>()
        ?.widget;
    return widget is TasksListWidgetModelProvider ? widget : null;
  }
}
