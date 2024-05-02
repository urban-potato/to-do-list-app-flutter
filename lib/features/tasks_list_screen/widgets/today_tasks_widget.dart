import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/tasks_list_screen/models/tasks_list_screen_model.dart';
import 'package:to_do_list_app/features/tasks_list_screen/widgets/no_tasks_widget.dart';
import 'package:to_do_list_app/features/tasks_list_screen/widgets/task_tile_widget.dart';
import 'package:to_do_list_app/resources/resources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TodayTasksWidget extends StatefulWidget {
  const TodayTasksWidget({super.key});

  @override
  State<TodayTasksWidget> createState() => _TodayTasksWidgetState();
}

class _TodayTasksWidgetState extends State<TodayTasksWidget> {
  final _model = TasksListScreenModel(boxName: HiveKeys.todayTasksBox);

  @override
  Widget build(BuildContext context) {
    return TasksListScreenModelProvider(
      model: _model,
      child: const _TodayTasksWidgetBody(),
    );
  }
}

class _TodayTasksWidgetBody extends StatelessWidget {
  const _TodayTasksWidgetBody();

  @override
  Widget build(BuildContext context) {
    final tasksListLength =
        TasksListScreenModelProvider.watch(context)?.model.tasksList?.length;

    return tasksListLength == null
        ? const Center(child: CircularProgressIndicator())
        : tasksListLength == 0
            ? NoTasksWidget(
                svgPicture: Svgs.personComputer,
                svgSemanticsLabel: AppLocalizations.of(context)!.personComputer,
                textUnderPicture: AppLocalizations.of(context)!.noTasksToday,
              )
            : _TasksWidget(tasksListLength: tasksListLength);
  }
}

class _TasksWidget extends StatelessWidget {
  const _TasksWidget({
    required this.tasksListLength,
  });

  final int tasksListLength;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasksListLength,
      itemBuilder: (context, index) => TaskTileWidget(taskIndex: index),
    );
  }
}
