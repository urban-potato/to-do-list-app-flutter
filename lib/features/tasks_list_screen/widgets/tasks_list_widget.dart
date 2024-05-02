import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/tasks_list_screen/models/tasks_list_widget_model.dart';
import 'package:to_do_list_app/features/tasks_list_screen/widgets/task_tile_widget.dart';

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
      child: _TasksWidgetBody(
        svgPicture: widget.svgPicture,
        svgSemanticsLabel: widget.svgSemanticsLabel,
        textUnderPicture: widget.textUnderPicture,
      ),
    );
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody({
    required this.svgPicture,
    required this.svgSemanticsLabel,
    required this.textUnderPicture,
  });

  final String svgPicture;
  final String svgSemanticsLabel;
  final String textUnderPicture;

  @override
  Widget build(BuildContext context) {
    final tasksListLength =
        TasksListWidgetModelProvider.watch(context)?.model.tasksList?.length;

    return tasksListLength == null
        ? const Center(child: CircularProgressIndicator())
        : tasksListLength == 0
            ? _NoTasksWidget(
                svgPicture: svgPicture,
                svgSemanticsLabel: svgSemanticsLabel,
                textUnderPicture: textUnderPicture,
              )
            : _TasksListBuilderWidget(tasksListLength: tasksListLength);
  }
}

class _NoTasksWidget extends StatelessWidget {
  const _NoTasksWidget({
    required this.svgPicture,
    required this.svgSemanticsLabel,
    required this.textUnderPicture,
  });

  final String svgPicture;
  final String svgSemanticsLabel;
  final String textUnderPicture;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgPicture,
          semanticsLabel: svgSemanticsLabel,
          fit: BoxFit.scaleDown,
          width: MediaQuery.of(context).size.width -
              AppMeasures.picturesPadding(context),
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
