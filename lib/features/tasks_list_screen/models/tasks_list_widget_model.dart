import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/data/data_provider/hive_box_manager.dart';
import 'package:to_do_list_app/data/entity/task.dart';

class TasksListWidgetModel extends ChangeNotifier {
  final String boxName;
  late final Box<Task> _box;
  ValueListenable<Box<Task>>? _listenableBox;

  int _tasksListLength = 0;
  int get tasksListLength => _tasksListLength;

  TasksListWidgetModel._create({required this.boxName});

  static Future<TasksListWidgetModel> create(String boxName) async {
    final component = TasksListWidgetModel._create(boxName: boxName);
    await component._setup();
    return component;
  }

  Future<void> _setup() async {
    _box = await HiveBoxManager.instance.openTaskBox(boxName);
    _getTasksNumberFromHive();

    _listenableBox = _box.listenable();
    _listenableBox?.addListener(_getTasksNumberFromHive);

    if (boxName == HiveBoxManager.instance.keys.todayTasksBox) {
      await _moveOldTasksToOtherWhenNewDay();
    }
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_getTasksNumberFromHive);

    Future.delayed(Duration.zero, () async {
      await HiveBoxManager.instance.closeTaskBox(boxName);
    });

    super.dispose();
  }

  Future<void> _moveOldTasksToOtherWhenNewDay() async {
    if (!_box.isOpen) return;

    DateTime now = DateTime.now();
    DateTime todayDate = DateTime(now.year, now.month, now.day);

    final tasksToMove =
        _box.values.where((task) => task.dateTime.compareTo(todayDate) != 0);

    if (tasksToMove.isEmpty) return;

    final toBoxName = HiveBoxManager.instance.keys.otherTasksBox;
    final toBox = await HiveBoxManager.instance.openTaskBox(toBoxName);

    for (final task in tasksToMove) {
      await task.delete();
      await toBox.add(task);
    }

    await HiveBoxManager.instance.closeTaskBox(toBoxName);
  }

  void _getTasksNumberFromHive() {
    if (!_box.isOpen) return;

    _tasksListLength = _box.length;
    notifyListeners();
  }

  Task? getTaskFromHive(int taskIndex) {
    if (!_box.isOpen) return null;

    final task = _box.getAt(taskIndex);

    return task;
  }

  Future<void> deleteTask(Task task) async {
    if (!_box.isOpen) return;

    await task.delete();
  }

  Future<void> moveTaskFromTodayToTomorrowOrViceVersa(Task task) async {
    if (!_box.isOpen) return;

    String toBoxName;

    if (boxName == HiveBoxManager.instance.keys.todayTasksBox) {
      toBoxName = HiveBoxManager.instance.keys.otherTasksBox;
    } else {
      toBoxName = HiveBoxManager.instance.keys.todayTasksBox;
    }

    DateTime newTaskDateTime;

    if (boxName == HiveBoxManager.instance.keys.todayTasksBox) {
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
    if (!_box.isOpen) return;

    String toBoxName;

    await task.delete();

    if (boxName != HiveBoxManager.instance.keys.doneTasksBox) {
      task.isDone = true;
      toBoxName = HiveBoxManager.instance.keys.doneTasksBox;
    } else {
      final now = DateTime.now();
      final todayDateTime = DateTime(now.year, now.month, now.day);

      task.isDone = false;
      task.dateTime = todayDateTime;
      toBoxName = HiveBoxManager.instance.keys.todayTasksBox;
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
