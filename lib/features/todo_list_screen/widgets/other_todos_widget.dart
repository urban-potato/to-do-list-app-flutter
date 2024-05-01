import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/todo_list_screen/models/todo_list_model.dart';
import 'package:to_do_list_app/features/todo_list_screen/widgets/todo_tile_widget.dart';

class OtherToDosWidget extends StatefulWidget {
  const OtherToDosWidget({super.key});

  @override
  State<OtherToDosWidget> createState() => _OtherToDosWidgetState();
}

class _OtherToDosWidgetState extends State<OtherToDosWidget> {
  final _model = ToDoListModel(boxName: HiveKeys.otherToDosBox);

  @override
  Widget build(BuildContext context) {
    return ToDoListModelProvider(
      model: _model,
      child: const _OtherToDosWidgetBody(),
    );
  }
}

class _OtherToDosWidgetBody extends StatelessWidget {
  const _OtherToDosWidgetBody();

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
