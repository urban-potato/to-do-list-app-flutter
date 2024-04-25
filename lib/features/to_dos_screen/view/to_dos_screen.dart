import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/constants/constants.dart';
import 'package:to_do_list_app/features/to_dos_screen/widgets/language.dart';
import 'package:to_do_list_app/to_do_list_app.dart';

@RoutePage()
class ToDosScreen extends StatelessWidget {
  const ToDosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-dos'),
        titleSpacing: AppMeasures.padding(context),
        scrolledUnderElevation: 0,
        actions: const <Widget>[_ChangeLocaleDropdownButtonWidget()],
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   systemNavigationBarColor: AppColors.fourthDark, // Navigation bar
        //   statusBarColor: AppColors.fourthDark, // Status bar
        // ),
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
