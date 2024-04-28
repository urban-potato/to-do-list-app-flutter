import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/todo_list_screen/models/todo_list_model.dart';
import 'package:to_do_list_app/features/todo_list_screen/widgets/todo_tile.dart';

class ArchiveToDosWidget extends StatefulWidget {
  const ArchiveToDosWidget({super.key});

  @override
  State<ArchiveToDosWidget> createState() => _ArchiveToDosWidgetState();
}

class _ArchiveToDosWidgetState extends State<ArchiveToDosWidget> {
  final _model = ToDoListModel(boxName: HiveKeys.archiveToDosBox);

  @override
  Widget build(BuildContext context) {
    return ToDoListModelProvider(
      model: _model,
      child: const _ArcgiveToDosWidgetBody(),
    );
  }
}

class _ArcgiveToDosWidgetBody extends StatelessWidget {
  const _ArcgiveToDosWidgetBody();

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
