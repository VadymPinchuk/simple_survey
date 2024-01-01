import 'package:flutter/widgets.dart';
import 'package:simple_survey/list/surveys_list_screen.dart';

class AdminWebScreen extends StatelessWidget {
  const AdminWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SurveysListScreen(),
        ),
      ],
    );
  }
}
