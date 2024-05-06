import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/data/entities/task.dart';
import 'package:to_do_list_app/features/tasks_list_screen/models/tasks_list_widget_model.dart';
import 'package:to_do_list_app/router/router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskTileWidget extends StatelessWidget {
  const TaskTileWidget({super.key, required this.taskIndex});

  final int taskIndex;

  @override
  Widget build(BuildContext context) {
    final model = TasksListWidgetModelProvider.read(context)!.model;
    final task = model.getTaskFromHive(taskIndex);

    final isTaskDone = task?.isDone ?? false;

    final taskColor =
        isTaskDone ? AppColors.mainGreenDark : AppColors.secondaryDark;

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
                task: task,
              ),
      ),
    );
  }
}

class _TaskInfoWidget extends StatelessWidget {
  const _TaskInfoWidget({
    required this.model,
    required this.task,
  });

  final TasksListWidgetModel model;
  final Task task;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime todayDate = DateTime(now.year, now.month, now.day);

    final isTodayTask = task.dateTime.compareTo(todayDate) == 0;

    final String moveLabel = isTodayTask
        ? AppLocalizations.of(context)!.tomorrow
        : AppLocalizations.of(context)!.today;
    final IconData moveIcon = isTodayTask
        ? Icons.keyboard_double_arrow_right_rounded
        : Icons.keyboard_double_arrow_left_rounded;

    void handleSlidableActionMoveTap(BuildContext context) =>
        model.moveTaskFromTodayToTomorrowOrViceVersa(task);
    void handleSlidableActionDeleteTap(BuildContext context) =>
        model.deleteTask(task);

    final SlidableAction slidableActionMove = SlidableAction(
      onPressed: handleSlidableActionMoveTap,
      backgroundColor: AppColors.mainGreen,
      foregroundColor: AppColors.mainTextDark,
      icon: moveIcon,
      label: moveLabel,
      padding: EdgeInsets.zero,
    );

    final SlidableAction slidableActionDelete = SlidableAction(
      onPressed: handleSlidableActionDeleteTap,
      backgroundColor: AppColors.mainRed,
      foregroundColor: AppColors.mainTextDark,
      icon: Icons.delete,
      label: AppLocalizations.of(context)!.delete,
      padding: EdgeInsets.zero,
    );

    final isTaskDone = task.isDone;

    final List<SlidableAction> slidableActions = isTaskDone
        ? [slidableActionDelete]
        : [slidableActionMove, slidableActionDelete];

    final double slidableExtentRatio = isTaskDone ? 0.24 : 0.45;

    final splashColor =
        isTaskDone ? AppColors.splashGreen : AppColors.splashGray;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: slidableExtentRatio,
          motion: const ScrollMotion(),
          children: slidableActions,
        ),
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: splashColor,
            highlightColor: splashColor,
            onTap: () {
              AutoRouter.of(context).push(TaskRoute(task: task));
            },
            child: ListTile(
              leading: _CheckBoxWidget(
                task: task,
                model: model,
              ),
              title: Text(
                task.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 16),
              ),
              trailing: const Icon(Icons.chevron_right, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckBoxWidget extends StatelessWidget {
  const _CheckBoxWidget({
    required this.task,
    required this.model,
  });

  final Task task;
  final TasksListWidgetModel model;

  @override
  Widget build(BuildContext context) {
    final isTaskDone = task.isDone;
    final checkBoxColor = isTaskDone ? AppColors.thirdDark : Colors.transparent;
    final splashColor =
        isTaskDone ? AppColors.splashSuperLightGray : AppColors.splashLightGray;

    return SizedBox(
      height: 24,
      width: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          color: checkBoxColor,
          border: Border.all(color: AppColors.thirdDark, width: 2.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              splashColor: splashColor,
              highlightColor: splashColor,
              onTap: () => model.completeOrUncompleteTask(task),
              child: isTaskDone
                  ? Icon(Icons.done, color: AppColors.mainGreenDark)
                  : null),
        ),
      ),
    );
  }
}
