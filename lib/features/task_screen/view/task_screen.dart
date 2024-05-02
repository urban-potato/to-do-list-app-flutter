import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/task_screen/models/task_screen_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key, required this.taskIndex, required this.boxName});

  final int taskIndex;
  final String boxName;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TaskScreenModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _model ??=
        TaskScreenModel(taskIndex: widget.taskIndex, boxName: widget.boxName);
  }

  @override
  Widget build(BuildContext context) {
    return TaskScreenModelProvider(
      model: _model!,
      child: const _TaskScreenBody(),
    );
  }
}

class _TaskScreenBody extends StatelessWidget {
  const _TaskScreenBody();

  @override
  Widget build(BuildContext context) {
    final model = TaskScreenModelProvider.watch(context)?.model;
    final task = model?.task;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.task),
        titleSpacing: AppMeasures.padding(context),
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppMeasures.padding(context),
          ),
          child: Center(
              child: task != null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          _TaskNameWidget(taskName: task.name),
                          const SizedBox(height: 10),
                          _TaskDetailsWidget(taskDetails: task.details),
                          const SizedBox(height: 26),
                          const _SaveButtonWidget(),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _TaskNameWidget extends StatefulWidget {
  const _TaskNameWidget({required this.taskName});

  final String taskName;

  @override
  State<_TaskNameWidget> createState() => _TaskNameWidgetState();
}

class _TaskNameWidgetState extends State<_TaskNameWidget> {
  late TextEditingController? taskNameController;

  @override
  void initState() {
    super.initState();

    taskNameController = TextEditingController(
      text: widget.taskName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: taskNameController,
      decoration: _TextFieldDecoration.decoration.copyWith(
        hintText: AppLocalizations.of(context)!.taskNamePlaceholder,
        hintStyle: Theme.of(context).textTheme.titleSmall,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      textCapitalization: TextCapitalization.sentences,
      keyboardAppearance: Brightness.dark,
      minLines: null,
      maxLines: null,
      maxLength: 256,
      // textAlign: TextAlign.justify,
      textInputAction: TextInputAction.next,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (String value) =>
          TaskScreenModelProvider.read(context)?.model.taskName = value,
    );
  }
}

class _TaskDetailsWidget extends StatefulWidget {
  const _TaskDetailsWidget({
    required this.taskDetails,
  });

  final String taskDetails;

  @override
  State<_TaskDetailsWidget> createState() => _TaskDetailsWidgetState();
}

class _TaskDetailsWidgetState extends State<_TaskDetailsWidget> {
  late TextEditingController? taskDetailsController;

  @override
  void initState() {
    super.initState();

    taskDetailsController = TextEditingController(
      text: widget.taskDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: taskDetailsController,
      decoration: _TextFieldDecoration.decoration.copyWith(
        hintText: AppLocalizations.of(context)!.taskDetailsPlaceholder,
        hintStyle: Theme.of(context).textTheme.titleSmall,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      textCapitalization: TextCapitalization.sentences,
      keyboardAppearance: Brightness.dark,
      minLines: null,
      maxLines: null,
      // textAlign: TextAlign.justify,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (String value) =>
          TaskScreenModelProvider.read(context)?.model.taskDetails = value,
    );
  }
}

class _SaveButtonWidget extends StatelessWidget {
  const _SaveButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () =>
                TaskScreenModelProvider.read(context)?.model.saveTask(),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.mainGreen),
              foregroundColor:
                  MaterialStateProperty.all(AppColors.mainTextDark),
              textStyle: MaterialStateProperty.all(
                  Theme.of(context).textTheme.titleMedium),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ),
      ],
    );
  }
}

abstract class _TextFieldDecoration {
  const _TextFieldDecoration();

  static final decoration = InputDecoration(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.thirdDark),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.mainGreen),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
    isCollapsed: true,
  );
}