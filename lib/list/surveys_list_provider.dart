import 'dart:async';

import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/models/survey.dart';

class SurveysListProvider {
  SurveysListProvider(this._repository);

  final Repository _repository;

  Stream<List<Survey>> get streamOfSurveys => _repository.streamOfSurveys;
  Future<List<Survey>> getSurveysList() => _repository.getSurveysList();
}
