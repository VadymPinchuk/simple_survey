import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/survey.dart';

/// Survey creation/edition provider
class ConstructorProvider extends ChangeNotifier {
  ConstructorProvider(this._repository);

  final Repository _repository;

  late String _surveyId;
  Survey? _survey;

  String get surveyId => _surveyId;

  Survey? get survey => _survey;

  /// Opening survey for edit or creating new survey
  Future<void> selectSurvey(String surveyId) async {
    _surveyId = surveyId;
    await _getSurveyById();
  }

  Future<void> _getSurveyById() async {
    if (_survey == null || _survey?.id != _surveyId) {
      if (surveyId.trim().isEmpty) {
        _survey = Survey.empty();
      } else {
        _survey = await _repository.getSurveyById(surveyId);
      }
      notifyListeners();
    }
  }

  /// Update survey title
  void setTitle(String title) {
    _survey = survey!.copyWith(title: title);
    notifyListeners();
  }

  /// Update survey description
  void setDescription(String description) {
    _survey = survey!.copyWith(description: description);
    notifyListeners();
  }

  /// Update survey status - active or inactive
  /// Not used at the moment
  void changeState(bool isActive) {
    _survey = survey!.copyWith(isActive: isActive);
    notifyListeners();
  }

  /// Update survey questions
  void changeQuestion(SurveyQuestion question) {
    final List<SurveyQuestion> questionsList = survey!.questions;
    final int indexOf = questionsList.indexWhere((e) => e.id == question.id);
    if (indexOf == -1) {
      questionsList.add(question);
    } else {
      questionsList.removeAt(indexOf);
      questionsList.insert(indexOf, question);
    }
    _survey = survey!.copyWith(questions: questionsList);
    notifyListeners();
  }

  /// API to delete question from the survey.
  /// Not used at the moment
  void deleteQuestion(SurveyQuestion question) {
    final List<SurveyQuestion> questionsList = survey!.questions;
    final int indexOf = questionsList.indexWhere((e) => e.id == question.id);
    if (indexOf != -1) {
      questionsList.removeAt(indexOf);
    }
    _survey = survey!.copyWith(questions: questionsList);
    notifyListeners();
  }

  /// API to save the current state of the survey on the Firebase
  Future<void> saveSurvey() async {
    if (_survey != null) {
      await _repository.createOrUpdateSurvey(survey!);
      _survey = null;
    }
  }
}
