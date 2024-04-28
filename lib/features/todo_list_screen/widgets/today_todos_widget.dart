import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/todo_list_screen/models/todo_list_model.dart';
import 'package:to_do_list_app/features/todo_list_screen/widgets/todo_tile.dart';

class TodayToDosWidget extends StatefulWidget {
  const TodayToDosWidget({super.key});

  @override
  State<TodayToDosWidget> createState() => _TodayToDosWidgetState();
}

class _TodayToDosWidgetState extends State<TodayToDosWidget> {
  final _model = ToDoListModel(boxName: HiveKeys.todayToDosBox);

  @override
  Widget build(BuildContext context) {
    return ToDoListModelProvider(
      model: _model,
      child: const _TodayToDosWidgetBody(),
    );
  }
}

class _TodayToDosWidgetBody extends StatelessWidget {
  const _TodayToDosWidgetBody();

  @override
  Widget build(BuildContext context) {
    final toDoListLength =
        ToDoListModelProvider.watch(context)?.model.toDoList.length ?? 0;

    return ListView.builder(
      itemCount: toDoListLength,
      itemBuilder: (context, index) => ToDoTileWidget(toDoIndex: index),
    );
  }
}
