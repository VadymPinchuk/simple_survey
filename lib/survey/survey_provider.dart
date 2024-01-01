import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/util/device_data.dart';

typedef Score = ({String id, double score, double current});

/// SurveyProvider to be taken
/// Not editable but for voting
class SurveyProvider extends ChangeNotifier {
  SurveyProvider(this._repository);

  final Repository _repository;

  Map<String, dynamic> _deviceData = <String, dynamic>{};

  late String _surveyId;
  Survey? _survey;

  Survey? get survey => _survey;

  Future<void> selectSurvey(String surveyId) async {
    _surveyId = surveyId;
    await _fetchSurvey();
  }

  Future<void> _fetchSurvey() async {
    if (_survey == null || _surveyId != _survey?.id) {
      _survey = await _repository.getSurveyById(_surveyId);
      _deviceData = (await DeviceInfoPlugin().deviceInfo).data;
      await _repository.saveRespondent(_deviceData);
      notifyListeners();
    }
  }

  void updateProgress(SurveyQuestion question) {
    final List<SurveyQuestion> questionsList = survey!.questions;
    final int indexOf = questionsList.indexWhere((e) => e.id == question.id);
    if (indexOf == -1) {
      questionsList.add(question);
    } else {
      questionsList.removeAt(indexOf);
      questionsList.insert(indexOf, question);
    }
    _survey = survey!.copyWith(questions: List.from(questionsList));
  }

  Future<void> sendResponse() async {
    await _repository.sendResponse(_deviceData.hashCode.toString(), _survey!);
  }
}
