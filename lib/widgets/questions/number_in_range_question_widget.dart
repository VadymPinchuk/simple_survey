import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/question/question_edit_dialog.dart';
import 'package:simple_survey/constructor/question/question_edit_provider.dart';
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

  Widget _buildEditButton(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          context.read<QuestionEditProvider>().editQuestion(question);
          showDialog(
            context: context,
            builder: (BuildContext context) => const QuestionEditDialog(),
          );
        },
      ),
    );
  }

  @override
  Widget childSpecificUI(BuildContext context) {
    return Slider(
      value: question.minValue,
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
