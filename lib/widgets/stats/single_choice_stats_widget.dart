import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/single_choice_survey_question.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/widgets/charts/bar_chart.dart';
import 'package:simple_survey/widgets/stats/base_stats_widget.dart';

class SingleChoiceStatsWidget extends BaseStatsWidget<SingleChoiceSurveyQuestion> {
  const SingleChoiceStatsWidget({
    super.key,
    required super.question,
    required super.dataStream,
  });

  @override
  Widget childSpecificUI(BuildContext context, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChart(
        count: data[QuestionKey.numOfResponses],
        data: data[SingleChoiceQuestionKey.options],
      ),
    );
  }
}
