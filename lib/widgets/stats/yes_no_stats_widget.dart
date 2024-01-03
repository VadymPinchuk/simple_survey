import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/questions/yes_no_survey_question.dart';
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
    final positive = data[YesNoQuestionKey.yesValue];
    final negative = data[YesNoQuestionKey.noValue];
    final total = data[QuestionKey.numOfResponses];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: positive / total,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.grey.shade300,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            '${positive.toStringAsFixed(0)} / ${negative.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
