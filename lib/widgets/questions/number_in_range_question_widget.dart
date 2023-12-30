import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';
import 'package:simple_survey/survey/survey_provider.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';

class NumberInRangeQuestionWidget
    extends BaseQuestionWidget<NumberInRangeSurveyQuestion> {
  const NumberInRangeQuestionWidget(
    super.question,
    super.mode, {
    super.key,
  });

  @override
  Widget childSpecificUI(BuildContext context) {
    return Slider(
      value: question.selectedValue.toDouble(),
      min: question.minValue.toDouble(),
      max: question.maxValue.toDouble(),
      divisions: question.maxValue - question.minValue,
      label: question.selectedValue.toString(),
      onChanged: (value) {
        context.read<SurveyProvider>();
      },
    );
  }
}
