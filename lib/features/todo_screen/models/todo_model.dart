import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/entity/todo.dart';

class ToDoModel extends ChangeNotifier {
  final int toDoIndex;
  final String boxName;

  ToDo? _toDo;
  ToDo? get toDo => _toDo;

  late String toDoName;
  late String toDoDetails;

  ToDoModel({
    required this.toDoIndex,
    required this.boxName,
  }) {
    _setup();
  }

  void saveToDO() async {
    if (toDoName.isEmpty) return;
    if (toDoName == _toDo?.name && toDoDetails == _toDo?.details) return;

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ToDoAdapter());
    }

    final box = await Hive.openBox<ToDo>(boxName);

    _toDo?.name = toDoName;
    _toDo?.details = toDoDetails;

    if (_toDo != null) {
      await box.putAt(toDoIndex, _toDo!);
    }
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ToDoAdapter());
    }

    final box = await Hive.openBox<ToDo>(boxName);

    _toDo = box.getAt(toDoIndex);

    toDoName = _toDo?.name ?? '';
    toDoDetails = _toDo?.details ?? '';

    notifyListeners();
  }
}

class ToDoModelProvider extends InheritedNotifier {
  const ToDoModelProvider(
      {super.key, required super.child, required this.model})
      : super(notifier: model);

  final ToDoModel model;

  static ToDoModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ToDoModelProvider>();
  }

  static ToDoModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ToDoModelProvider>()
        ?.widget;
    return widget is ToDoModelProvider ? widget : null;
  }
}
