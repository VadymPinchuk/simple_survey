import 'package:flutter/widgets.dart';
import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';
import 'package:simple_survey/widgets/questions/number_in_range_question_widget.dart';

extension QuestionToWidget on SurveyQuestion {
  Widget toQuestionWidget(QuestionMode mode) {
    return switch (type) {
      _ => NumberInRangeQuestionWidget(
          this as NumberInRangeSurveyQuestion,
          mode,
          key: Key(toString()),
        ),
    };
  }
}
