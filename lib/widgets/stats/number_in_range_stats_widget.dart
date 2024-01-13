import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';
import 'package:simple_survey/widgets/charts/circle_chart.dart';
import 'package:simple_survey/widgets/stats/base_stats_widget.dart';

class NumberInRangeStatsWidget extends BaseStatsWidget<NumberInRangeSurveyQuestion> {
  const NumberInRangeStatsWidget({
    super.key,
    required super.question,
    required super.dataStream,
    this.size = 100.0,
    this.strokeWidth = 15.0,
  });

  final double size;
  final double strokeWidth;

  @override
  Widget childSpecificUI(BuildContext context, Map<String, dynamic> data) {
    final selected = data[NumberQuestionKey.selectedValue];
    final max = data[NumberQuestionKey.maxValue];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleChart(
        averageScore: selected,
        maxScore: max,
      ),
    );
  }
}
