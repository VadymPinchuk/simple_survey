import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/models/questions/question_to_widget_transformer.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/stats/stats_provider.dart';
import 'package:simple_survey/widgets/loader.dart';
import 'package:simple_survey/widgets/logo_blur.dart';

const String _url =
    'https://static.wixstatic.com/media/6e1ab2_82fe1012f6fb45b3b1a7fcf042969adc~mv2.png/v1/fill/w_660,h_574,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/dcam23-landmark.png';

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
          body: Stack(
            children: [
              LogoBlur(name: survey.imageName),
              SingleChildScrollView(
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
                    Wrap(
                      children: survey.questions.map((question) {
                        return Selector<StatsProvider, Stream<Map<String, dynamic>>>(
                          selector: (_, provider) => provider.streams[question.id]!,
                          builder: (_, stream, __) {
                            return question.toStatsWidget(stream);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
