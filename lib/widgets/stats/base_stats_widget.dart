import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/survey_question.dart';

enum QuestionMode { edit, submit }

/// Widget with basic UI - title
abstract class BaseStatsWidget<T extends SurveyQuestion>
    extends StatelessWidget {
  const BaseStatsWidget({
    super.key,
    required this.question,
  });

  final T question;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                question.title,
                style: text.titleMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox.square(dimension: 16.0),
              childSpecificUI(context),
            ],
          ),
        ),
      ),
    );
  }

  /// UI specific to each child implementation:
  /// Slider, RangeSlider, Number, ets
  Widget childSpecificUI(BuildContext context);
}
