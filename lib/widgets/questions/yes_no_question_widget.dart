import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/yes_no_survey_question.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';

/// Widget for a simple Yes/No question
class YesNoQuestionWidget extends BaseQuestionWidget<YesNoSurveyQuestion> {
  const YesNoQuestionWidget({
    super.key,
    required super.question,
    required super.mode,
    super.onChanged,
  });

  @override
  Widget childSpecificUI(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('NO'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Switch(
            value: question.selectedValue,
            onChanged: (value) {
              onChanged?.call(
                question.copyWith(
                  key: YesNoQuestionKey.selectedValue,
                  value: value,
                ),
              );
            },
          ),
        ),
        const Text('YES'),
      ],
    );
  }
}
