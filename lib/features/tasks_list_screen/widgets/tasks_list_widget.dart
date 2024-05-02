import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/tasks_list_screen/models/tasks_list_widget_model.dart';
import 'package:to_do_list_app/features/tasks_list_screen/widgets/task_tile_widget.dart';
import 'package:to_do_list_app/resources/resources.dart';

class TasksListWidget extends StatefulWidget {
  const TasksListWidget({
    super.key,
    required this.boxName,
    required this.svgPicture,
    required this.svgSemanticsLabel,
    required this.textUnderPicture,
  });

  final String boxName;
  final String svgPicture;
  final String svgSemanticsLabel;
  final String textUnderPicture;

  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  late final TasksListWidgetModel _model;

  @override
  void initState() {
    super.initState();

    _model = TasksListWidgetModel(boxName: widget.boxName);
  }

  @override
  Widget build(BuildContext context) {
    return TasksListWidgetModelProvider(
      model: _model,
      child: const _TasksWidgetBody(),
    );
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody();

  @override
  Widget build(BuildContext context) {
    final tasksListLength =
        TasksListWidgetModelProvider.watch(context)?.model.tasksList?.length;

    return tasksListLength == null
        ? const Center(child: CircularProgressIndicator())
        : tasksListLength == 0
            ? const _NoTasksWidget()
            : _TasksListBuilderWidget(tasksListLength: tasksListLength);
  }
}

class _NoTasksWidget extends StatelessWidget {
  const _NoTasksWidget();

  @override
  Widget build(BuildContext context) {
    final pictureWidth = MediaQuery.of(context).size.width -
        AppMeasures.picturesPadding(context);
    final String svgPicture =
        context.findAncestorWidgetOfExactType<TasksListWidget>()?.svgPicture ??
            Svgs.personComputer;
    final String svgSemanticsLabel = context
            .findAncestorWidgetOfExactType<TasksListWidget>()
            ?.svgSemanticsLabel ??
        '';
    final String textUnderPicture = context
            .findAncestorWidgetOfExactType<TasksListWidget>()
            ?.textUnderPicture ??
        '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgPicture,
          semanticsLabel: svgSemanticsLabel,
          fit: BoxFit.scaleDown,
          width: pictureWidth,
        ),
        Center(
          child: Text(
            textUnderPicture,
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _TasksListBuilderWidget extends StatelessWidget {
  const _TasksListBuilderWidget({
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
