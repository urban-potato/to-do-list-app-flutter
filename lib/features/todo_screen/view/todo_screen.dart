import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/constants.dart';
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
  const _ToDoScreenBody();

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
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          _ToDoNameWidget(toDoName: toDo.name),
                          const SizedBox(height: 10),
                          _ToDoDetailsWidget(toDoDetails: toDo.details),
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

class _ToDoNameWidget extends StatefulWidget {
  const _ToDoNameWidget({required this.toDoName});

  final String toDoName;

  @override
  State<_ToDoNameWidget> createState() => _ToDoNameWidgetState();
}

class _ToDoNameWidgetState extends State<_ToDoNameWidget> {
  late TextEditingController? toDoNameController;

  @override
  void initState() {
    super.initState();

    toDoNameController = TextEditingController(
      text: widget.toDoName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: toDoNameController,
      decoration: _TextFieldDecoration.decoration.copyWith(
        hintText: AppLocalizations.of(context)!.toDoTitlePlaceholder,
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
          ToDoModelProvider.read(context)?.model.toDoName = value,
    );
  }
}

class _ToDoDetailsWidget extends StatefulWidget {
  const _ToDoDetailsWidget({
    required this.toDoDetails,
  });

  final String toDoDetails;

  @override
  State<_ToDoDetailsWidget> createState() => _ToDoDetailsWidgetState();
}

class _ToDoDetailsWidgetState extends State<_ToDoDetailsWidget> {
  late TextEditingController? toDoDetailsController;

  @override
  void initState() {
    super.initState();

    toDoDetailsController = TextEditingController(
      text: widget.toDoDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: toDoDetailsController,
      decoration: _TextFieldDecoration.decoration.copyWith(
        hintText: AppLocalizations.of(context)!.toDoDetailsPlaceholder,
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
          ToDoModelProvider.read(context)?.model.toDoDetails = value,
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
            onPressed: () => ToDoModelProvider.read(context)?.model.saveToDO(),
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
