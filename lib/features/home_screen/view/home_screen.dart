import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/home_screen/models/language.dart';
import 'package:to_do_list_app/features/home_screen/widgets/archive_to_dos_widget.dart';
import 'package:to_do_list_app/features/home_screen/widgets/other_to_dos_widget.dart';
import 'package:to_do_list_app/features/home_screen/widgets/today_to_dos_widget.dart';
import 'package:to_do_list_app/to_do_list_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      TodayToDosWidget(),
      OtherToDosWidget(),
      ArchiveToDosWidget(),
    ];

    List<String> titles = [
      AppLocalizations.of(context)!.today,
      AppLocalizations.of(context)!.other,
      AppLocalizations.of(context)!.archive,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentPageIndex]),
        titleSpacing: AppMeasures.padding(context),
        scrolledUnderElevation: 0,
        actions: const <Widget>[_ChangeLocaleDropdownButtonWidget()],
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   systemNavigationBarColor: AppColors.fourthDark, // Navigation bar
        //   statusBarColor: AppColors.fourthDark, // Status bar
        // ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppMeasures.padding(context),
        ),
        child: widgets[currentPageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        // height: 60,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        indicatorColor: AppColors.mainGreen,
        // indicatorShape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        destinations: <Widget>[
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
            label: AppLocalizations.of(context)!.today,
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.list,
              color: AppColors.mainDark,
              size: 26,
            ),
            icon: Icon(
              Icons.list_outlined,
              color: AppColors.secondaryTextDark,
              size: 26,
            ),
            label: AppLocalizations.of(context)!.other,
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.archive,
              color: AppColors.mainDark,
              size: 26,
            ),
            icon: Icon(
              Icons.archive_outlined,
              color: AppColors.secondaryTextDark,
              size: 26,
            ),
            label: AppLocalizations.of(context)!.archive,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.newToDo,
        child: const Icon(
          Icons.add_rounded,
          size: 30,
        ),
        onPressed: () {},
      ),
    );
  }
}

class _ChangeLocaleDropdownButtonWidget extends StatelessWidget {
  const _ChangeLocaleDropdownButtonWidget({
    super.key,
  });

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
    super.key,
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
