import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:to_do_list_app/data/entity/task.dart';

class HiveBoxManager {
  static final HiveBoxManager instance = HiveBoxManager._();

  final Map<String, int> _boxCounter = {};
  final int taskAdapterTypeId = 0;

  final HiveBoxesKeys _keys = const HiveBoxesKeys._();
  HiveBoxesKeys get keys => _keys;

  HiveBoxManager._();

  Future<Box<Task>> openTaskBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      final counter = _boxCounter[boxName] ?? 1;
      _boxCounter[boxName] = counter + 1;
      GetIt.I<Talker>()
          .info('(1 open (was open) - $boxName) _boxCounter = $_boxCounter');
      return Hive.box<Task>(boxName);
    }

    _boxCounter[boxName] = 1;
    if (!Hive.isAdapterRegistered(taskAdapterTypeId)) {
      Hive.registerAdapter(TaskAdapter());
    }
    GetIt.I<Talker>().info(
        '(2 open (was closed, we open) - $boxName) _boxCounter = $_boxCounter');
    return Hive.openBox<Task>(boxName);
  }

  Future<void> closeTaskBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      _boxCounter.remove(boxName);
      GetIt.I<Talker>()
          .info('(1 close (was closed) - $boxName) _boxCounter = $_boxCounter');
      return;
    }

    var counter = _boxCounter[boxName] ?? 1;
    counter -= 1;
    _boxCounter[boxName] = counter;
    if (counter > 0) {
      GetIt.I<Talker>().info(
          '(2 close (was open, remain open, reduce counter) - $boxName) _boxCounter = $_boxCounter');
      return;
    }

    _boxCounter.remove(boxName);

    final box = Hive.box<Task>(boxName);

    await box.compact();
    await box.close();
    GetIt.I<Talker>().info(
        '(3 close (was open, we close) - $boxName) _boxCounter = $_boxCounter');
  }
}

class HiveBoxesKeys {
  final todayTasksBox = 'today_tasks_box';
  final otherTasksBox = 'other_tasks_box';
  final doneTasksBox = 'done_tasks_box';

  const HiveBoxesKeys._();
}
