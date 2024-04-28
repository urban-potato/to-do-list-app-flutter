import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/entity/todo.dart';

class ToDoListModel extends ChangeNotifier {
  final String boxName;
  var _toDoList = <ToDo>[];
  List<ToDo> get toDoList => _toDoList.toList();

  ToDoListModel({required this.boxName}) {
    _setup();
  }

  void deleteToDo(int toDoIndex) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ToDoAdapter());
    }

    final box = await Hive.openBox<ToDo>(boxName);

    await box.deleteAt(toDoIndex);
  }

  void moveToDo(int toDoIndex) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ToDoAdapter());
    }

    final fromBox = await Hive.openBox<ToDo>(boxName);
    ToDo? toDo = fromBox.getAt(toDoIndex);
    if (toDo == null) return;

    String toBoxName;
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    if (boxName != HiveKeys.archiveToDosBox) {
      // toDo.done = false;
      toBoxName = HiveKeys.archiveToDosBox;
    } else {
      if (toDo.dateTime.compareTo(date) == 0) {
        toBoxName = HiveKeys.todayToDosBox;
      } else {
        toBoxName = HiveKeys.otherToDosBox;
      }
    }

    final toBox = await Hive.openBox<ToDo>(toBoxName);

    toBox.add(toDo);
    deleteToDo(toDoIndex);
  }

  void _getToDosFromHive(Box<ToDo> box) {
    _toDoList = box.values.toList();
    notifyListeners();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ToDoAdapter());
    }

    final box = await Hive.openBox<ToDo>(boxName);
    _getToDosFromHive(box);

    box.listenable().addListener(() => _getToDosFromHive(box));
  }
}

class ToDoListModelProvider extends InheritedNotifier {
  const ToDoListModelProvider({
    super.key,
    required super.child,
    required this.model,
  }) : super(notifier: model);

  final ToDoListModel model;

  static ToDoListModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ToDoListModelProvider>();
  }

  static ToDoListModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ToDoListModelProvider>()
        ?.widget;
    return widget is ToDoListModelProvider ? widget : null;
  }

  // @override
  // bool updateShouldNotify(ToDoListModelProvider oldWidget) {
  //   return true;
  // }
}
