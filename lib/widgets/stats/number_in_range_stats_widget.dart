import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';
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
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: selected / max,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.grey.shade300,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            '${selected.toStringAsFixed(1)} / ${max.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
