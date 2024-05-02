import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/entity/task.dart';
import 'package:to_do_list_app/features/tasks_list_screen/models/tasks_list_screen_model.dart';
import 'package:to_do_list_app/router/router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskTileWidget extends StatelessWidget {
  const TaskTileWidget({super.key, required this.taskIndex});

  final int taskIndex;

  @override
  Widget build(BuildContext context) {
    final model = TasksListScreenModelProvider.read(context)!.model;
    final task = model.tasksList?[taskIndex];
    final taskColor = task?.isDone ?? false
        ? AppColors.mainGreenDark
        : AppColors.secondaryDark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: taskColor,
        ),
        child: task == null
            ? const Center(child: CircularProgressIndicator())
            : _TaskInfoWidget(
                model: model,
                taskIndex: taskIndex,
                task: task,
              ),
      ),
    );
  }
}

class _TaskInfoWidget extends StatelessWidget {
  const _TaskInfoWidget({
    required this.model,
    required this.taskIndex,
    required this.task,
  });

  final TasksListScreenModel model;
  final int taskIndex;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.24,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                model.deleteTask(taskIndex);
              },
              backgroundColor: AppColors.mainRed,
              foregroundColor: AppColors.mainTextDark,
              icon: Icons.delete,
              label: AppLocalizations.of(context)!.delete,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: AppColors.secondaryDark,
            onTap: () {
              AutoRouter.of(context).push(
                  TaskRoute(taskIndex: taskIndex, boxName: model.boxName));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: ListTile(
                leading: _CheckBoxWidget(
                    taskIndex: taskIndex, isDone: task.isDone, model: model),
                title: Text(
                  task.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: const Icon(Icons.chevron_right, size: 26),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckBoxWidget extends StatelessWidget {
  const _CheckBoxWidget({
    required this.taskIndex,
    required this.isDone,
    required this.model,
  });

  final int taskIndex;
  final bool isDone;
  final TasksListScreenModel model;

  @override
  Widget build(BuildContext context) {
    final splachColor = isDone ? AppColors.mainDark : AppColors.mainGreen;

    return SizedBox(
      height: 28,
      width: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.secondaryTextDark,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(8),
              splashColor: splachColor,
              onTap: () => model.completeOrUncompleteTask(taskIndex),
              child: isDone
                  ? Icon(Icons.done, color: AppColors.mainGreenDark)
                  : null),
        ),
      ),
    );
  }
}
