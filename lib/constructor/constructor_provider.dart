import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/models/survey_question.dart';

class ConstructorProvider extends ChangeNotifier {
  ConstructorProvider(this._repository);

  final Repository _repository;

  late String _surveyId;
  Survey? _survey;

  String get surveyId => _surveyId;

  Survey get survey => _survey!;

  Future<void> selectSurvey(String surveyId) async {
    _surveyId = surveyId;
    await _getSurveyById();
  }

  Future<void> _getSurveyById() async {
    if (_survey != null) return;
    if (surveyId.isNotEmpty) {
      _survey = await _repository.getSurveyById(surveyId);
    } else {
      _survey = Survey.empty();
    }
    notifyListeners();
  }

  void setTitle(String title) {
    _survey = survey.copyWith(title: title);
    notifyListeners();
  }

  void setDescription(String description) {
    _survey = survey.copyWith(description: description);
    notifyListeners();
  }

  void changeState(bool isActive) {
    _survey = survey.copyWith(isActive: isActive);
    notifyListeners();
  }

  void changeQuestion(SurveyQuestion question) {
    final List<SurveyQuestion> questionsList = survey.questions;
    final int indexOf = questionsList.indexWhere((e) => e.id == question.id);
    if (indexOf == -1) {
      questionsList.add(question);
    } else {
      questionsList.removeAt(indexOf);
      questionsList.insert(indexOf, question);
    }
    _survey = survey.copyWith(questions: List.from(questionsList));
    notifyListeners();
  }

  void saveSurvey() {
    if (_survey != null) {
      _repository.createOrUpdateSurvey(survey);
    }
  }
}