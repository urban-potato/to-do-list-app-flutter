import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/entity/todo.dart';

class ToDoModel extends ChangeNotifier {
  final int toDoIndex;
  final String boxName;

  // late final Future<Box<ToDo>> _box;

  ToDo? _toDo;
  ToDo? get toDo => _toDo;

  ToDoModel({
    required this.toDoIndex,
    required this.boxName,
  }) {
    _setup();
  }

  void _setup() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ToDoAdapter());
    }

    // _box = Hive.openBox<ToDo>(boxName);
    final box = await Hive.openBox<ToDo>(boxName);
    _getToDoFromHive(box);

    box.listenable().addListener(() => _getToDoFromHive(box));
  }

  void _getToDoFromHive(Box<ToDo> box) {
    // final box = await _box;
    _toDo = box.getAt(toDoIndex);
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

  // @override
  // bool updateShouldNotify(ToDoModelProvider oldWidget) {
  //   return true;
  // }
}
