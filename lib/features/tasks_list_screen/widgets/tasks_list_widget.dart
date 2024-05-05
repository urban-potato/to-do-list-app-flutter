import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
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
  Future<int>? _modelSetup;

  @override
  void initState() {
    GetIt.I<Talker>()
        .debug('(${widget.boxName}) ----- TasksListWidget initState -----');

    super.initState();

    _model = TasksListWidgetModel(boxName: widget.boxName);
    _modelSetup = _model.setupModel();
  }

  @override
  Future<void> dispose() async {
    GetIt.I<Talker>()
        .debug('(${widget.boxName}) ----- TasksListWidget dispose -----');

    // await _model.dispose();

    Future.delayed(Duration.zero, () async {
      await _model.dispose();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: _modelSetup,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return TasksListWidgetModelProvider(
              key: Key('${widget.boxName}_provider'),
              model: _model,
              child: const _TasksWidgetBody(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }

        // child: TasksListWidgetModelProvider(
        //   key: Key('${widget.boxName}_provider'),
        //   model: _model,
        //   child: const _TasksWidgetBody(),
        // ),
        );
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody();

  @override
  Widget build(BuildContext context) {
    final tasksListLength =
        TasksListWidgetModelProvider.watch(context)?.model.tasksListLength;

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
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.w100),
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
