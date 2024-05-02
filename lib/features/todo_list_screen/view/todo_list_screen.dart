import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/entity/todo.dart';
import 'package:to_do_list_app/features/todo_list_screen/models/language.dart';
import 'package:to_do_list_app/features/todo_list_screen/widgets/done_todos_widget.dart';
import 'package:to_do_list_app/features/todo_list_screen/widgets/other_todos_widget.dart';
import 'package:to_do_list_app/features/todo_list_screen/widgets/today_todos_widget.dart';
import 'package:to_do_list_app/router/router.dart';
import 'package:to_do_list_app/to_do_list_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _widgets = [
    const TodayToDosWidget(),
    const OtherToDosWidget(),
    const DoneToDosWidget(),
  ];

  List<String>? _titles;
  List<Widget>? _navigationItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _titles ??= [
      AppLocalizations.of(context)!.today,
      AppLocalizations.of(context)!.other,
      AppLocalizations.of(context)!.done,
    ];

    _navigationItems ??= [
      NavigationDestination(
        selectedIcon: Icon(
          Icons.today,
          color: AppColors.mainDark,
          size: 26,
        ),
        icon: Icon(
          Icons.today_outlined,
          color: AppColors.secondaryTextDark,
          size: 26,
        ),
        label: AppLocalizations.of(context)!.today,
      ),
      NavigationDestination(
        selectedIcon: Icon(
          Icons.list_alt,
          color: AppColors.mainDark,
          size: 26,
        ),
        icon: Icon(
          Icons.list_alt_outlined,
          color: AppColors.secondaryTextDark,
          size: 26,
        ),
        label: AppLocalizations.of(context)!.other,
      ),
      NavigationDestination(
        selectedIcon: Icon(
          Icons.task_alt,
          color: AppColors.mainDark,
          size: 26,
        ),
        icon: Icon(
          Icons.task_alt_outlined,
          color: AppColors.secondaryTextDark,
          size: 26,
        ),
        label: AppLocalizations.of(context)!.done,
      ),
    ];
  }

  void _handleNavigationItemTap(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  void _handleFloatingButtonTap(BuildContext context) {
    AutoRouter.of(context).push(const CreateToDoRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles![_currentPageIndex]),
        titleSpacing: AppMeasures.padding(context),
        scrolledUnderElevation: 0,
        actions: const <Widget>[_ChangeLocaleDropdownButtonWidget()],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppMeasures.padding(context),
          ),
          child: _widgets[_currentPageIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _handleNavigationItemTap,
        selectedIndex: _currentPageIndex,
        indicatorColor: AppColors.mainGreen,
        destinations: _navigationItems!,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleFloatingButtonTap(context),
        tooltip: AppLocalizations.of(context)!.newToDo,
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
      ),
    );
  }
}

class _ChangeLocaleDropdownButtonWidget extends StatelessWidget {
  const _ChangeLocaleDropdownButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: AppMeasures.padding(context)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Language>(
          value: null,
          dropdownColor: AppColors.fourthDark,
          icon: Icon(
            Icons.language,
            color: AppColors.mainTextDark,
            size: 28,
          ),
          onChanged: (Language? language) =>
              _handleChangeLocale(language, context),
          items: Language.languageList()
              .map<DropdownMenuItem<Language>>(
                (language) => DropdownMenuItem<Language>(
                  value: language,
                  child:
                      _ChangeLocaleDropdownMenuItemWidget(language: language),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _handleChangeLocale(Language? language, BuildContext context) async {
    if (language != null) {
      ToDoListApp.setLocale(
        context,
        language.languageCode,
      );

      final sharedPreferences = GetIt.I<SharedPreferences>();
      sharedPreferences.setString(
          SharedPreferencesKeys.locale, language.languageCode);
    }
  }
}

class _ChangeLocaleDropdownMenuItemWidget extends StatelessWidget {
  const _ChangeLocaleDropdownMenuItemWidget({
    required this.language,
  });

  final Language language;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          language.flag,
          style: const TextStyle(fontSize: 28, color: Colors.white),
        ),
        Text(
          language.name,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        )
      ],
    );
  }
}
