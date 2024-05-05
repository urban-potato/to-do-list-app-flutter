import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/data/entity/task.dart';

class HiveBoxManager {
  static final HiveBoxManager instance = HiveBoxManager._();
  final Map<String, int> _boxCounter = {};
  final int taskAdapterTypeId = 0;

  HiveBoxManager._();

  Future<Box<Task>> openTaskBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      final counter = _boxCounter[boxName] ?? 1;
      _boxCounter[boxName] = counter + 1;
      return Hive.box<Task>(boxName);
    }

    _boxCounter[boxName] = 1;
    if (!Hive.isAdapterRegistered(taskAdapterTypeId)) {
      Hive.registerAdapter(TaskAdapter());
    }
    return Hive.openBox<Task>(boxName);
  }

  Future<void> closeTaskBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      _boxCounter.remove(boxName);
      return;
    }

    var counter = _boxCounter[boxName] ?? 1;
    counter -= 1;
    _boxCounter[boxName] = counter;
    if (counter > 0) return;

    _boxCounter.remove(boxName);

    final box = Hive.box<Task>(boxName);

    await box.compact();
    await box.close();
  }

  // Future<void> closeBox<T>(Box<T> box) async {
  //   if (!box.isOpen) {
  //     _boxCounter.remove(box.name);
  //     return;
  //   }

  //   var counter = _boxCounter[box.name] ?? 1;
  //   counter -= 1;
  //   _boxCounter[box.name] = counter;
  //   if (counter > 0) return;

  //   _boxCounter.remove(box.name);

  //   await box.compact();
  //   await box.close();
  // }
}
