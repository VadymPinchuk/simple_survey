import 'package:flutter/widgets.dart';
import 'package:simple_survey/models/survey_question.dart';
import 'package:simple_survey/questions/single_number_question_widget.dart';

extension QuestionToWidget on SurveyQuestion {
  Widget toQuestionWidget() {
    return switch (type) {
      _ => SingleNumberQuestionWidget(
          key: Key(toString()),
          question: this,
          mode: QuestionMode.editable,
        ),
    };
  }
}
