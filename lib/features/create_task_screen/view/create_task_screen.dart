import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_list_app/features/create_task_screen/models/create_task_screen_model.dart';

@RoutePage()
class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _model = CreateTaskScreenModel();

  @override
  Widget build(BuildContext context) {
    return CreateTaskScreenModelProvider(
      model: _model,
      child: const _CreateTaskScreenBody(),
    );
  }
}

class _CreateTaskScreenBody extends StatelessWidget {
  const _CreateTaskScreenBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newTask),
        titleSpacing: AppMeasures.padding(context),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          statusBarColor: AppColors.mainDark,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppMeasures.padding(context),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const _TaskNameFieldWidget(),
              const SizedBox(height: 8),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.fourthDark,
              ),
              const SizedBox(height: 40),
              const _TaskDetailsFieldWidget(),
              const SizedBox(height: 40),
              const _SaveButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskNameFieldWidget extends StatelessWidget {
  const _TaskNameFieldWidget();

  @override
  Widget build(BuildContext context) {
    final model = CreateTaskScreenModelProvider.watch(context)?.model;

    return TextField(
      autofocus: true,
      decoration: _TextFieldDecoration.decoration.copyWith(
        hintText: AppLocalizations.of(context)!.taskNamePlaceholder,
        hintStyle: Theme.of(context).textTheme.titleSmall,
        counterText: '',
        errorText: model?.errorMessage,
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
      textCapitalization: TextCapitalization.sentences,
      keyboardAppearance: Brightness.dark,
      textInputAction: TextInputAction.done,
      minLines: null,
      maxLines: null,
      maxLength: 256,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (String value) =>
          CreateTaskScreenModelProvider.read(context)?.model.taskName = value,
      onEditingComplete: () =>
          CreateTaskScreenModelProvider.read(context)?.model.saveTask(context),
    );
  }
}

class _TaskDetailsFieldWidget extends StatelessWidget {
  const _TaskDetailsFieldWidget();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: _TextFieldDecoration.decoration.copyWith(
        hintText: AppLocalizations.of(context)!.taskDetailsPlaceholder,
        hintStyle: Theme.of(context).textTheme.titleSmall,
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
      textCapitalization: TextCapitalization.sentences,
      keyboardAppearance: Brightness.dark,
      textInputAction: TextInputAction.newline,
      minLines: null,
      maxLines: null,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (String value) => CreateTaskScreenModelProvider.read(context)
          ?.model
          .taskDetails = value,
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
            onPressed: () => CreateTaskScreenModelProvider.read(context)
                ?.model
                .saveTask(context),
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

  static const decoration = InputDecoration(
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    isCollapsed: true,
  );
}
