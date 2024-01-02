import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/student.dart';
import 'package:simple_survey/models/survey.dart';

class StatsProvider extends ChangeNotifier {
  StatsProvider(this._repository);

  final Repository _repository;
  final List<StreamSubscription> _subscriptions = List.empty(growable: true);
  String? _surveyId;
  Survey? _survey;

  Survey? get survey => _survey;

  String get surveyId => _surveyId!;

  Future<void> requestSurveyStats(String surveyId) async {
    if (surveyId != _surveyId) {
      _surveyId = surveyId;
      _survey = await _repository.getSurveyById(surveyId);
      List<SurveyQuestion> list = _survey!.questions;
      for (SurveyQuestion question in _survey!.questions) {
        // _students.add(Student(
        //   id: question.id,
        //   name: question.title,
        //   score: (question as NumberInRangeSurveyQuestion)
        //       .selectedValue
        //       .toDouble(),
        // ));
        _subscriptions.add(getQuestionResponsesStream(surveyId, question.id)
            .listen((response) {
          // FIXME: cleanup hardcode later
          int index = list.indexWhere((stud) => stud.id == question.id);
          SurveyQuestion newQuestion = list
              .removeAt(index)
              .copyWith(key: NumberQuestionKey.selectedValue, value: response.round());
          list.insert(index, newQuestion);
          list = List.from(list);
          _survey = _survey!.copyWith(questions: list);
          notifyListeners();
        }));
      }
      notifyListeners();
    }
  }

  // FIXME: hardcoded for one possible option only
  Stream<double> getQuestionResponsesStream(
    String surveyId,
    String questionId,
  ) {
    return _repository.getResponsesStream(surveyId, questionId).map((list) {
      // FIXME: think on different output for different questions
      var sum = list.fold(0.0, (prev, curr) {
        return prev + curr[NumberQuestionKey.selectedValue];
      });
      return sum / list.length;
    });
  }

  @override
  void dispose() {
    for (var element in _subscriptions) {
      element.cancel();
    }
    super.dispose();
  }
}
