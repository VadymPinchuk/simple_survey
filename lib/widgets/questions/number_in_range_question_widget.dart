import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/models/single_number_survey_question.dart';
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
      value: question.selectedValue,
      min: question.minValue,
      max: question.maxValue,
      divisions: 30,
      label: question.selectedValue.round().toString(),
      onChanged: (value) {
        context.read<SurveyProvider>();
      },
    );
  }
}
