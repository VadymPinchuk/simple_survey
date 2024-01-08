import 'package:flutter/widgets.dart';
import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';
import 'package:simple_survey/models/questions/single_choice_survey_question.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/questions/yes_no_survey_question.dart';
import 'package:simple_survey/util/uuid_generator.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';
import 'package:simple_survey/widgets/questions/number_in_range_question_widget.dart';
import 'package:simple_survey/widgets/questions/single_choice_question_widget.dart';
import 'package:simple_survey/widgets/questions/yes_no_question_widget.dart';
import 'package:simple_survey/widgets/stats/number_in_range_stats_widget.dart';
import 'package:simple_survey/widgets/stats/single_choice_stats_widget.dart';
import 'package:simple_survey/widgets/stats/yes_no_stats_widget.dart';

extension QuestionToWidget on SurveyQuestion {
  Widget toQuestionWidget({
    required QuestionMode mode,
    Function(SurveyQuestion)? onChanged,
  }) {
    if (mode == QuestionMode.submit && !isActive) {
      return const SizedBox.shrink();
    }
    return switch (type) {
      QuestionType.yesNo => YesNoQuestionWidget(
          key: Key(uuidFrom(toJson())),
          question: this as YesNoSurveyQuestion,
          mode: mode,
          onChanged: onChanged,
        ),
      QuestionType.singleChoice => SingleChoiceQuestionWidget(
          key: Key(uuidFrom(toJson())),
          question: this as SingleChoiceSurveyQuestion,
          mode: mode,
          onChanged: onChanged,
        ),
      _ => NumberInRangeQuestionWidget(
          key: Key(uuidFrom(toJson())),
          question: this as NumberInRangeSurveyQuestion,
          mode: mode,
          onChanged: onChanged,
        ),
    };
  }

  Widget toStatsWidget(Stream<Map<String, dynamic>> dataStream) {
    return switch (type) {
      QuestionType.yesNo => YesNoStatsWidget(
          key: Key(uuidFrom(toJson())),
          question: this as YesNoSurveyQuestion,
          dataStream: dataStream,
        ),
      QuestionType.singleChoice => SingleChoiceStatsWidget(
        key: Key(uuidFrom(toJson())),
        question: this as SingleChoiceSurveyQuestion,
        dataStream: dataStream,
      ),
      _ => NumberInRangeStatsWidget(
          key: Key(uuidFrom(toJson())),
          question: this as NumberInRangeSurveyQuestion,
          dataStream: dataStream,
        ),
    };
  }
}
