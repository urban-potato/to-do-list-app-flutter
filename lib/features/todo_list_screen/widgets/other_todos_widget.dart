import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/todo_list_screen/models/todo_list_model.dart';
import 'package:to_do_list_app/features/todo_list_screen/widgets/todo_tile_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_list_app/resources/resources.dart';

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
          Svgs.personMeditate,
          semanticsLabel: AppLocalizations.of(context)!.personMeditate,
          fit: BoxFit.scaleDown,
          width: MediaQuery.of(context).size.width -
              AppMeasures.picturesPadding(context),
        ),
        Center(
          child: Text(
            AppLocalizations.of(context)!.noTasksOtherDays,
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
