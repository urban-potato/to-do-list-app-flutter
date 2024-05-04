import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/data/data_provider/hive_box_manager.dart';
import 'package:to_do_list_app/data/entity/task.dart';

class TasksListWidgetModel extends ChangeNotifier {
  final String boxName;

  List<Task>? _tasksList;
  List<Task>? get tasksList => _tasksList?.toList();

  TasksListWidgetModel({required this.boxName}) {
    _setup();
  }

  void deleteTask(int taskIndex) async {
    final box = await HiveBoxManager.instance.openTaskBox(boxName);

    await box.deleteAt(taskIndex);
  }

  void moveTaskFromTodayToTomorrowOrViceVersa(
      int taskIndex, bool isTodayTask) async {
    String fromBoxName;
    String toBoxName;

    if (isTodayTask) {
      fromBoxName = HiveKeys.todayTasksBox;
      toBoxName = HiveKeys.otherTasksBox;
    } else {
      fromBoxName = HiveKeys.otherTasksBox;
      toBoxName = HiveKeys.todayTasksBox;
    }

    final fromBox = await HiveBoxManager.instance.openTaskBox(fromBoxName);
    Task? task = fromBox.getAt(taskIndex);
    if (task == null) return;

    DateTime newTaskDateTime;

    if (isTodayTask) {
      newTaskDateTime = DateTime(
          task.dateTime.year, task.dateTime.month, task.dateTime.day + 1);
    } else {
      DateTime now = DateTime.now();
      newTaskDateTime = DateTime(now.year, now.month, now.day);
    }

    task.dateTime = newTaskDateTime;

    final toBox = await HiveBoxManager.instance.openTaskBox(toBoxName);

    toBox.add(task);
    await fromBox.deleteAt(taskIndex);
  }

  void completeOrUncompleteTask(int taskIndex) async {
    final fromBox = await HiveBoxManager.instance.openTaskBox(boxName);

    Task? task = fromBox.getAt(taskIndex);
    if (task == null) return;

    String toBoxName;
    final now = DateTime.now();
    final todayDateTime = DateTime(now.year, now.month, now.day);

    if (boxName != HiveKeys.doneTasksBox) {
      task.isDone = true;
      toBoxName = HiveKeys.doneTasksBox;
    } else {
      task.isDone = false;
      task.dateTime = todayDateTime;
      toBoxName = HiveKeys.todayTasksBox;
    }

    final toBox = await HiveBoxManager.instance.openTaskBox(toBoxName);

    toBox.add(task);
    await fromBox.deleteAt(taskIndex);
  }

  void _getTasksFromHive(Box<Task> box) {
    _tasksList = box.values.toList();
    notifyListeners();
  }

  void _setup() async {
    final box = await HiveBoxManager.instance.openTaskBox(boxName);
    _getTasksFromHive(box);

    box.listenable().addListener(() => _getTasksFromHive(box));
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
