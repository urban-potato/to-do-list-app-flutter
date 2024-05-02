import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppMeasures.padding(context),
        ),
        child: const Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _TaskNameFieldWidget(),
                SizedBox(height: 10),
                _TaskDetailsFieldWidget(),
                SizedBox(height: 20),
                _SaveButtonWidget(),
              ],
            ),
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
    return TextField(
      autofocus: true,
      decoration: _getTextFieldDecoration(context).copyWith(
          hintText: AppLocalizations.of(context)!.taskNamePlaceholder),
      style: Theme.of(context).textTheme.bodyMedium,
      textCapitalization: TextCapitalization.sentences,
      keyboardAppearance: Brightness.dark,
      textInputAction: TextInputAction.next,
      minLines: null,
      maxLines: null,
      maxLength: 256,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (String value) =>
          CreateTaskScreenModelProvider.read(context)?.model.taskName = value,
    );
  }
}

class _TaskDetailsFieldWidget extends StatelessWidget {
  const _TaskDetailsFieldWidget();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: _getTextFieldDecoration(context).copyWith(
          hintText: AppLocalizations.of(context)!.taskDetailsPlaceholder),
      style: Theme.of(context).textTheme.bodyMedium,
      textCapitalization: TextCapitalization.sentences,
      keyboardAppearance: Brightness.dark,
      // textInputAction: TextInputAction.done,
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

InputDecoration _getTextFieldDecoration(BuildContext context) {
  return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.thirdDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.mainGreen),
      ),
      isCollapsed: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      hintStyle: Theme.of(context).textTheme.titleSmall);
}
