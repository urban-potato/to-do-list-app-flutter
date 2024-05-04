part of 'constants.dart';

abstract class AppMeasures {
  static double padding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.035;
  }

  static double picturesPadding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.15;
  }
}
