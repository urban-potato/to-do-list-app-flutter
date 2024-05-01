import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/todo_list_screen/models/todo_list_model.dart';
import 'package:to_do_list_app/router/router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToDoTileWidget extends StatelessWidget {
  const ToDoTileWidget({super.key, required this.toDoIndex});

  final int toDoIndex;

  @override
  Widget build(BuildContext context) {
    final model = ToDoListModelProvider.read(context)!.model;
    final toDo = model.toDoList[toDoIndex];
    final toDoColor =
        toDo.isDone ? AppColors.mainGreenDark : AppColors.secondaryDark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: toDoColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Slidable(
            endActionPane: ActionPane(
              extentRatio: 0.24,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    model.deleteToDo(toDoIndex);
                  },
                  backgroundColor: AppColors.mainRed,
                  foregroundColor: AppColors.mainTextDark,
                  icon: Icons.delete,
                  label: AppLocalizations.of(context)!.delete,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              elevation: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: AppColors.secondaryDark,
                onTap: () {
                  AutoRouter.of(context).push(
                      ToDoRoute(toDoIndex: toDoIndex, boxName: model.boxName));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: ListTile(
                    leading: _CheckBoxWidget(
                        toDoIndex: toDoIndex,
                        isDone: toDo.isDone,
                        model: model),
                    title: Text(
                      toDo.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 26),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckBoxWidget extends StatelessWidget {
  const _CheckBoxWidget({
    required this.toDoIndex,
    required this.isDone,
    required this.model,
  });

  final int toDoIndex;
  final bool isDone;
  final ToDoListModel model;

  @override
  Widget build(BuildContext context) {
    final splachColor = isDone ? AppColors.mainDark : AppColors.mainGreen;

    return SizedBox(
      height: 28,
      width: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.secondaryTextDark,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(8),
              splashColor: splachColor,
              onTap: () => model.moveToDo(toDoIndex),
              child: isDone
                  ? Icon(Icons.done, color: AppColors.mainGreenDark)
                  : null),
        ),
      ),
    );
  }
}
