import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/survey.dart';

class StatsProvider extends ChangeNotifier {
  StatsProvider(this._repository);

  final Repository _repository;

  String? _surveyId;
  Survey? _survey;

  /// question responses stream
  final streams = <String, Stream<Map<String, dynamic>>>{};

  Survey? get survey => _survey;

  Future<void> requestSurveyStats(String surveyId) async {
    if (surveyId != _surveyId) {
      _surveyId = surveyId;
      _survey = await _repository.getSurveyById(surveyId);
      for (SurveyQuestion question in _survey!.questions) {
        streams.putIfAbsent(
          question.id,
          () => getQuestionResponsesStream(surveyId, question),
        );
      }
      notifyListeners();
    }
  }

  Stream<Map<String, dynamic>> getQuestionResponsesStream(
    String surveyId,
    SurveyQuestion question,
  ) {
    return _repository
        .getResponsesStream(surveyId, question.id)
        .map(question.responsesToStats);
  }
}
