import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/todo_list_screen/models/todo_list_model.dart';

class ToDoTileWidget extends StatelessWidget {
  const ToDoTileWidget({super.key, required this.toDoIndex});

  final int toDoIndex;

  @override
  Widget build(BuildContext context) {
    final model = ToDoListModelProvider.read(context)!.model;
    final toDo = model.toDoList[toDoIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.secondaryDark,
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
                  label: 'Delete',
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: ListTile(
                leading: IconButton(
                  onPressed: () => model.moveToDo(toDoIndex),
                  icon: Icon(Icons.check_box),
                ),
                title: Text(
                  toDo.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: const Icon(Icons.chevron_right, size: 26),
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
