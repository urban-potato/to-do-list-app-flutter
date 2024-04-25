import 'package:to_do_list_app/constants/constants.dart';

class Language {
  const Language(this.id, this.flag, this.name, this.languageCode);

  final int id;
  final String flag;
  final String name;
  final String languageCode;

  static List<Language> languageList() {
    return const <Language>[
      Language(1, '🇺🇸', 'English', LocalesKeys.english),
      Language(2, '🇷🇺', 'Русский', LocalesKeys.russian),
    ];
  }
}
