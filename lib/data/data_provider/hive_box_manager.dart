import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/data/entity/task.dart';

class HiveBoxManager {
  static final HiveBoxManager instance = HiveBoxManager._();

  HiveBoxManager._();


  Future<Box<Task>> openTaskBox(String boxName) async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }

    return Hive.openBox<Task>(boxName);
  }

  Future<void> closeBox<T>(Box<T> box) async {
    await box.compact();
    await box.close();
  }
}
