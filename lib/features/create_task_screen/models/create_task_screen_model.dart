import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/data/data_provider/hive_box_manager.dart';
import 'package:to_do_list_app/data/entity/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateTaskScreenModel extends ChangeNotifier {
  var _taskName = '';
  var taskDetails = '';
  String? errorMessage;

  set taskName(String value) {
    if (errorMessage != null && value.trim().isNotEmpty) {
      errorMessage = null;
      notifyListeners();
    }
    _taskName = value;
  }

  Future<void> saveTask(BuildContext context) async {
    final taskName = _taskName.trim();

    if (taskName.isEmpty) {
      errorMessage = AppLocalizations.of(context)!.enterTask;
      notifyListeners();
      return;
    }

    const boxName = HiveKeys.todayTasksBox;

    final box = await HiveBoxManager.instance.openTaskBox(boxName);

    DateTime now = DateTime.now();
    final task = Task(
      name: taskName,
      details: taskDetails,
      dateTime: DateTime(now.year, now.month, now.day),
    );

    await box.add(task);
    await HiveBoxManager.instance.closeTaskBox(boxName);

    if (context.mounted) AutoRouter.of(context).maybePop();
  }
}

class CreateTaskScreenModelProvider extends InheritedNotifier {
  const CreateTaskScreenModelProvider({
    super.key,
    required super.child,
    required this.model,
  }) : super(notifier: model);

  final CreateTaskScreenModel model;

  static CreateTaskScreenModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CreateTaskScreenModelProvider>();
  }

  static CreateTaskScreenModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<
            CreateTaskScreenModelProvider>()
        ?.widget;
    return widget is CreateTaskScreenModelProvider ? widget : null;
  }
}
