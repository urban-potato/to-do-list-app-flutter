import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/todo_list_screen/models/todo_list_model.dart';
import 'package:to_do_list_app/features/todo_list_screen/widgets/todo_tile_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_list_app/resources/resources.dart';

class DoneToDosWidget extends StatefulWidget {
  const DoneToDosWidget({super.key});

  @override
  State<DoneToDosWidget> createState() => _DoneToDosWidgetState();
}

class _DoneToDosWidgetState extends State<DoneToDosWidget> {
  final _model = ToDoListModel(boxName: HiveKeys.doneToDosBox);

  @override
  Widget build(BuildContext context) {
    return ToDoListModelProvider(
      model: _model,
      child: const _DoneToDosWidgetBody(),
    );
  }
}

class _DoneToDosWidgetBody extends StatelessWidget {
  const _DoneToDosWidgetBody();

  @override
  Widget build(BuildContext context) {
    final toDoListLength =
        ToDoListModelProvider.watch(context)?.model.toDoList?.length;

    return toDoListLength == null
        ? const Center(child: CircularProgressIndicator())
        : toDoListLength == 0
            ? const _NoToDosWidget()
            : _ToDosWidget(toDoListLength: toDoListLength);
  }
}

class _ToDosWidget extends StatelessWidget {
  const _ToDosWidget({
    required this.toDoListLength,
  });

  final int toDoListLength;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: toDoListLength,
      itemBuilder: (context, index) => ToDoTileWidget(toDoIndex: index),
    );
  }
}

class _NoToDosWidget extends StatelessWidget {
  const _NoToDosWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Svgs.personTasks,
          semanticsLabel: AppLocalizations.of(context)!.personTasks,
          fit: BoxFit.scaleDown,
          width: MediaQuery.of(context).size.width -
              AppMeasures.picturesPadding(context),
        ),
        Center(
          child: Text(
            AppLocalizations.of(context)!.noTasksDone,
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
