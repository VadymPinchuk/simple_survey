import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/models/questions/question_to_widget_transformer.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/stats/stats_provider.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.surveyId});

  final String surveyId;

  @override
  State<StatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void didChangeDependencies() {
    context.read<StatsProvider>().requestSurveyStats(widget.surveyId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.chart_screen_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Stack(
          children: [
            Selector<StatsProvider, List<SurveyQuestion>>(
              selector: (_, provider) =>
                  provider.survey?.questions ?? List.empty(),
              builder: (context, list, __) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:
                      list.map((question) => question.toStatsWidget()).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
