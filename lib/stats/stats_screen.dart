import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/models/questions/question_to_widget_transformer.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/stats/stats_provider.dart';
import 'package:simple_survey/widgets/loader.dart';

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
    return Selector<StatsProvider, Survey?>(
      selector: (_, provider) => provider.survey,
      builder: (context, survey, _) {
        if (survey == null) return const Loader();
        // final strings = AppLocalizations.of(context)!;
        final textTheme = Theme.of(context).textTheme;
        return Scaffold(
          appBar: AppBar(
            title: Text(survey.title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    survey.description,
                    style: textTheme.bodyLarge,
                  ),
                ),
                Selector<StatsProvider, Map>(
                  selector: (_, provider) => provider.streams,
                  builder: (context, streams, _) {
                    return Wrap(
                      children: survey.questions
                          .map((question) => question.toStatsWidget(streams[question.id]))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
