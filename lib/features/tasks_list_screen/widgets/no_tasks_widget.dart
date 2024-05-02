import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do_list_app/constants/constants.dart';

class NoTasksWidget extends StatelessWidget {
  const NoTasksWidget({
    super.key,
    required this.svgPicture,
    required this.svgSemanticsLabel,
    required this.textUnderPicture,
  });

  final String svgPicture;
  final String svgSemanticsLabel;
  final String textUnderPicture;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          svgPicture,
          semanticsLabel: svgSemanticsLabel,
          fit: BoxFit.scaleDown,
          width: MediaQuery.of(context).size.width -
              AppMeasures.picturesPadding(context),
        ),
        Center(
          child: Text(
            textUnderPicture,
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
