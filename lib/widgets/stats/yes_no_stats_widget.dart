import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/yes_no_survey_question.dart';
import 'package:simple_survey/widgets/pie_chart.dart';
import 'package:simple_survey/widgets/stats/base_stats_widget.dart';

class YesNoStatsWidget extends BaseStatsWidget<YesNoSurveyQuestion> {
  const YesNoStatsWidget({
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PieChart(
            data: [data[YesNoQuestionKey.yesValue], data[YesNoQuestionKey.noValue]],
            labels: const ['Yes', 'No'],
            chartRadius: size / 2,
          ),
        ],
      ),
    );
  }
}
