import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/entity/todo.dart';
import 'package:to_do_list_app/features/todo_screen/models/todo_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key, required this.toDoIndex, required this.boxName});

  final int toDoIndex;
  final String boxName;

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  ToDoModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _model ??= ToDoModel(toDoIndex: widget.toDoIndex, boxName: widget.boxName);
  }

  @override
  Widget build(BuildContext context) {
    return ToDoModelProvider(
      model: _model!,
      child: const _ToDoScreenBody(),
    );
  }
}

class _ToDoScreenBody extends StatelessWidget {
  const _ToDoScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = ToDoModelProvider.watch(context)?.model;
    final toDo = model?.toDo;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.toDo),
        titleSpacing: AppMeasures.padding(context),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppMeasures.padding(context),
          ),
          child: Center(
            child: toDo != null
                ? _ToDoInfoWidget(toDo: toDo)
                : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class _ToDoInfoWidget extends StatelessWidget {
  const _ToDoInfoWidget({required this.toDo});

  final ToDo toDo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(toDo.name),
          Text(toDo.details),
        ],
      ),
    );
  }
}
