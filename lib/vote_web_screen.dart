import 'package:flutter/widgets.dart';
import 'package:simple_survey/chart/chart_screen.dart';
import 'package:simple_survey/vote/vote_screen.dart';

class VoteWebScreen extends StatelessWidget {
  const VoteWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    if (size.width > size.height) {
      return Row(
        children: widgets,
      );
    } else {
      return Column(
        children: widgets,
      );
    }
  }

  List<Widget> get widgets {
    return const <Widget>[
      Expanded(
        flex: 1,
        child: VoteScreen(),
      ),
      Expanded(
        flex: 2,
        child: ChartScreen(),
      ),
    ];
  }
}
