import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/widgets/loader.dart';

enum QuestionMode { edit, submit }

/// Widget with basic UI - title
abstract class BaseStatsWidget<T extends SurveyQuestion> extends StatelessWidget {
  const BaseStatsWidget({
    super.key,
    required this.question,
    required this.dataStream,
  });

  final T question;
  final Stream<Map<String, dynamic>> dataStream;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<Map<String, dynamic>>(
            stream: dataStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Loader();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    snapshot.requireData[QuestionKey.title],
                    style: text.titleMedium!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Number of respondents: ${snapshot.requireData[QuestionKey.numOfResponses]}',
                    style: text.titleMedium,
                  ),
                  const SizedBox.square(dimension: 16.0),
                  childSpecificUI(context, snapshot.requireData),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// UI specific to each child implementation:
  /// Slider, RangeSlider, Number, ets
  Widget childSpecificUI(BuildContext context, Map<String, dynamic> data);
}
