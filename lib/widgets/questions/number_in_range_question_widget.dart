import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';
import 'package:simple_survey/widgets/debounced_slider.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';

class NumberInRangeQuestionWidget
    extends BaseQuestionWidget<NumberInRangeSurveyQuestion> {
  const NumberInRangeQuestionWidget({
    super.key,
    required super.question,
    required super.mode,
    super.onChanged,
  });

  @override
  Widget childSpecificUI(BuildContext context) {
    return DebouncedSlider(
      value: question.selectedValue.toDouble(),
      min: question.minValue.toDouble(),
      max: question.maxValue.toDouble(),
      onChanged: (value) {
        onChanged?.call(
          question.copyWith(
            key: NumberQuestionKey.selectedValue,
            value: value.round(),
          ),
        );
      },
    );
  }
}
