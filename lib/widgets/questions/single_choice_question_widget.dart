import 'package:flutter/material.dart';
import 'package:simple_survey/models/questions/single_choice_survey_question.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';

class SingleChoiceQuestionWidget extends BaseQuestionWidget<SingleChoiceSurveyQuestion> {
  const SingleChoiceQuestionWidget({
    super.key,
    required super.question,
    required super.mode,
    super.onChanged,
  });

  @override
  Widget childSpecificUI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: question.options.map((option) {
        return RadioListTile<int>(
          title: Text(option.label),
          value: option.id,
          groupValue: question.selectedId,
          contentPadding: const EdgeInsets.all(0.0),
          onChanged: (int? newIndex) {
            final list = question.options;
            if (question.selectedId != -1) {
              final oldSelection = list.removeAt(question.selectedId).copyWith(isSelected: false);
              list.insert(question.selectedId, oldSelection);
            }
            final newSelection = list.removeAt(newIndex!).copyWith(isSelected: true);
            list.insert(newIndex, newSelection);
            if (onChanged != null) {
              final newQuestion = question.copyWith(
                {
                  SingleChoiceQuestionKey.options: list,
                  SingleChoiceQuestionKey.selectedId: newIndex,
                },
              );
              onChanged!.call(newQuestion);
            }
          },
        );
      }).toList(),
    );
  }
}
