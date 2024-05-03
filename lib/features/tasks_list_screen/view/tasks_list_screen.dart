import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/tasks_list_screen/models/language.dart';
import 'package:to_do_list_app/features/tasks_list_screen/widgets/tasks_list_widget.dart';
import 'package:to_do_list_app/resources/resources.dart';
import 'package:to_do_list_app/router/router.dart';
import 'package:to_do_list_app/to_do_list_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  int _currentPageIndex = 0;

  List<Widget>? _widgets;
  List<String>? _titles;
  List<Widget>? _navigationItems;

  String? _locale;

  @override
  void initState() {
    super.initState();
    _locale = ToDoListApp.getLocale(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentLocale = ToDoListApp.getLocale(context);

    if (_widgets != null &&
        _titles != null &&
        _navigationItems != null &&
        currentLocale == _locale) return;

    _locale = currentLocale;
    _updateData(context);
  }

  void _updateData(BuildContext context) {
    _widgets = [
      TasksListWidget(
        key: const Key(HiveKeys.todayTasksBox),
        boxName: HiveKeys.todayTasksBox,
        svgPicture: Svgs.personComputer,
        svgSemanticsLabel: AppLocalizations.of(context)!.personComputer,
        textUnderPicture: AppLocalizations.of(context)!.noTasksToday,
      ),
      TasksListWidget(
        key: const Key(HiveKeys.otherTasksBox),
        boxName: HiveKeys.otherTasksBox,
        svgPicture: Svgs.personMeditate,
        svgSemanticsLabel: AppLocalizations.of(context)!.personMeditate,
        textUnderPicture: AppLocalizations.of(context)!.noTasksOtherDays,
      ),
      TasksListWidget(
        key: const Key(HiveKeys.doneTasksBox),
        boxName: HiveKeys.doneTasksBox,
        svgPicture: Svgs.personTasks,
        svgSemanticsLabel: AppLocalizations.of(context)!.personTasks,
        textUnderPicture: AppLocalizations.of(context)!.noTasksDone,
      ),
    ];

    _titles = [
      AppLocalizations.of(context)!.today,
      AppLocalizations.of(context)!.other,
      AppLocalizations.of(context)!.done,
    ];

    const double navigationIconsSize = 24;

    _navigationItems = [
      NavigationDestination(
        selectedIcon: Icon(
          Icons.today,
          color: AppColors.mainDark,
          size: navigationIconsSize,
        ),
        icon: Icon(
          Icons.today_outlined,
          color: AppColors.secondaryTextDark,
          size: navigationIconsSize,
        ),
        label: AppLocalizations.of(context)!.today,
      ),
      NavigationDestination(
        selectedIcon: Icon(
          Icons.list_alt,
          color: AppColors.mainDark,
          size: navigationIconsSize,
        ),
        icon: Icon(
          Icons.list_alt_outlined,
          color: AppColors.secondaryTextDark,
          size: navigationIconsSize,
        ),
        label: AppLocalizations.of(context)!.other,
      ),
      NavigationDestination(
        selectedIcon: Icon(
          Icons.task_alt,
          color: AppColors.mainDark,
          size: navigationIconsSize,
        ),
        icon: Icon(
          Icons.task_alt_outlined,
          color: AppColors.secondaryTextDark,
          size: navigationIconsSize,
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
    AutoRouter.of(context).push(const CreateTaskRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles![_currentPageIndex]),
        titleSpacing: AppMeasures.padding(context),
        scrolledUnderElevation: 0,
        actions: const <Widget>[_ChangeLocaleDropdownButtonWidget()],
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black, // Navigation bar
          statusBarColor: AppColors.mainDark, // Status bar
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppMeasures.padding(context),
          ),
          child: _widgets?[_currentPageIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _handleNavigationItemTap,
        selectedIndex: _currentPageIndex,
        indicatorColor: AppColors.mainGreen,
        // indicatorColor: Colors.transparent,
        // indicatorShape: StadiumBorder(side: BorderSide.none),
        // indicatorShape: RoundedRectangleBorder(),
        // elevation: 50,
        // shadowColor: Colors.black,
        height: 60,
        destinations: _navigationItems!,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleFloatingButtonTap(context),
        tooltip: AppLocalizations.of(context)!.newTask,
        child: const Icon(
          Icons.add_rounded,
          size: 26,
        ),
      ),
    );
  }
}

class _ChangeLocaleDropdownButtonWidget extends StatelessWidget {
  const _ChangeLocaleDropdownButtonWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppMeasures.padding(context)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Language>(
          // padding: EdgeInsets.only(right: AppMeasures.padding(context)),

          // padding: EdgeInsets.zero,

          value: null,
          dropdownColor: AppColors.fourthDark,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(
            Icons.language,
            color: AppColors.mainTextDark,
            size: 24,
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
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ),
        Text(
          language.name,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        )
      ],
    );
  }
}
