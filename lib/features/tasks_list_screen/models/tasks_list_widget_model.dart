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
  // late final Future<Box<Task>> _box;
  ValueListenable<Box<Task>>? _listenableBox;

  int _tasksListLength = 0;
  int get tasksListLength => _tasksListLength;

  TasksListWidgetModel({required this.boxName}) {
    GetIt.I<Talker>().debug('TasksListWidgetModel init');
    // _setup();
  }

  Future<int> setupModel() async {
    GetIt.I<Talker>().debug('TasksListWidgetModel _setup');

    final box = await HiveBoxManager.instance.openTaskBox(boxName);
    await _getTasksNumberFromHive();

    _listenableBox = box.listenable();
    _listenableBox?.addListener(_getTasksNumberFromHive);

    return 0;
  }

  // Future<void> _setup() async {
  //   GetIt.I<Talker>().debug('TasksListWidgetModel _setup');

  //   final box = await HiveBoxManager.instance.openTaskBox(boxName);
  //   await _getTasksNumberFromHive();

  //   _listenableBox = box.listenable();
  //   _listenableBox?.addListener(_getTasksNumberFromHive);
  // }

  @override
  Future<void> dispose() async {
    GetIt.I<Talker>().debug('TasksListWidgetModel dispose');

    _listenableBox?.removeListener(_getTasksNumberFromHive);

    // await HiveBoxManager.instance.closeTaskBox(boxName);

    Future.delayed(Duration.zero, () async {
      await HiveBoxManager.instance.closeTaskBox(boxName);
    });

    super.dispose();
  }

  Future<void> _getTasksNumberFromHive() async {
    final box = await HiveBoxManager.instance.openTaskBox(boxName);
    _tasksListLength = box.length;
    await HiveBoxManager.instance.closeTaskBox(boxName);

    notifyListeners();
  }

  Future<Task?> getTaskFromHive(int taskIndex) async {
    final box = await HiveBoxManager.instance.openTaskBox(boxName);
    final task = box.getAt(taskIndex);
    await HiveBoxManager.instance.closeTaskBox(boxName);

    return task;
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }

  Future<void> moveTaskFromTodayToTomorrowOrViceVersa(
      Task task, bool isTodayTask) async {
    String toBoxName;

    if (isTodayTask) {
      toBoxName = HiveKeys.otherTasksBox;
    } else {
      toBoxName = HiveKeys.todayTasksBox;
    }

    DateTime newTaskDateTime;

    if (isTodayTask) {
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
