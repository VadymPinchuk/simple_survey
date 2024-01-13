import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/util/device_data.dart';
import 'package:simple_survey/util/uuid_generator.dart';

typedef Score = ({String id, double score, double current});

/// SurveyProvider to be taken
/// Not editable but for voting
class SurveyProvider extends ChangeNotifier {
  SurveyProvider(this._repository);

  final Repository _repository;

  late String _respondentUuid;

  late String _surveyId;
  Survey? _survey;

  Survey? get survey => _survey;

  final List<SurveyQuestion> _questionsList = List.empty(growable: true);

  List<SurveyQuestion> get questionsList => _questionsList;

  Future<void> selectSurvey(String surveyId) async {
    _surveyId = surveyId;
    await _fetchSurvey();
  }

  Future<void> _fetchSurvey() async {
    final deviceData = await readPlatformData();
    _respondentUuid = uuidFrom(deviceData);
    final Survey survey = await _repository.getSurveyById(_surveyId);
    if (_survey == null || _surveyId != _survey!.id || survey.lastUpdate != _survey!.lastUpdate) {
      _survey = survey;
      _questionsList
        ..clear()
        ..addAll(_survey!.questions);
      await _repository.saveRespondent(deviceData);
      notifyListeners();
    }
  }

  void updateProgress(SurveyQuestion question) {
    final int indexOf = _questionsList.indexWhere((e) => e.id == question.id);
    if (indexOf == -1) {
      _questionsList.add(question);
    } else {
      _questionsList.removeAt(indexOf);
      _questionsList.insert(indexOf, question);
    }
    notifyListeners();
  }

  Future<void> sendResponse() async {
    _survey = survey!.copyWith(questions: questionsList);
    await _repository.sendResponse(_respondentUuid, _survey!);
    _survey = null;
    _questionsList.clear();
  }
}
