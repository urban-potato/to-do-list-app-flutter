import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_list_app/features/create_todo_screen/models/create_todo_model.dart';

@RoutePage()
class CreateToDoScreen extends StatefulWidget {
  const CreateToDoScreen({super.key});

  @override
  State<CreateToDoScreen> createState() => _CreateToDoScreenState();
}

class _CreateToDoScreenState extends State<CreateToDoScreen> {
  final _model = CreateToDoModel();

  @override
  Widget build(BuildContext context) {
    return CreateToDoModelProvider(
      model: _model,
      child: const _CreateToDoWidget(),
    );
  }
}

class _CreateToDoWidget extends StatelessWidget {
  const _CreateToDoWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newToDo),
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
                _ToDoNameFieldWidget(),
                SizedBox(height: 10),
                _ToDoDetailsFieldWidget(),
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

class _ToDoNameFieldWidget extends StatelessWidget {
  const _ToDoNameFieldWidget();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: _getTextFieldDecoration(context).copyWith(
          hintText: AppLocalizations.of(context)!.toDoTitlePlaceholder),
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
      onChanged: (value) =>
          CreateToDoModelProvider.read(context)?.model.toDoName = value,
      // onEditingComplete: () =>
      //     CreateToDoModelProvider.read(context)?.model.saveToDO(context),
    );
  }
}

class _ToDoDetailsFieldWidget extends StatelessWidget {
  const _ToDoDetailsFieldWidget();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: _getTextFieldDecoration(context).copyWith(
          hintText: AppLocalizations.of(context)!.toDoDetailsPlaceholder),
      style: Theme.of(context).textTheme.bodyMedium,
      textCapitalization: TextCapitalization.sentences,
      keyboardAppearance: Brightness.dark,
      // textInputAction: TextInputAction.done,
      minLines: null,
      maxLines: null,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: (value) =>
          CreateToDoModelProvider.read(context)?.model.toDoDetails = value,
      // onEditingComplete: () =>
      //     CreateToDoModelProvider.read(context)?.model.saveToDO(context),
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
                CreateToDoModelProvider.read(context)?.model.saveToDO(context),
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
