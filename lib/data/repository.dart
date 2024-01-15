import 'package:simple_survey/data/firebase_client.dart';
import 'package:simple_survey/models/survey.dart';

class Repository {
  Repository() {
    _client = FirebaseClient();
  }

  late FirebaseClient _client;

  Future<Survey> getSurveyById(String surveyId) async {
    return await _client.getSurveyById(surveyId);
  }

  Future<List<Survey>> getSurveysList() {
    return _client.getSurveysList();
  }

  Future<Survey> copySurvey(Survey survey) {
    return _client.copySurvey(survey);
  }

  Stream<List<Survey>> streamOfSurveys() {
    return _client.getSurveysStream();
  }

  Future<void> createOrUpdateSurvey(Survey survey) async {
    if (survey.id.isEmpty) {
      await _client.createSurvey(survey);
    } else {
      await _client.updateSurvey(survey);
    }
  }

  Future<void> saveRespondent(Map<String, dynamic> data) async {
    await _client.saveRespondent(data);
  }

  Future<void> sendResponse(String respondentId, Survey survey) async {
    await _client.sendResponse(respondentId, survey);
  }

  Stream<List<Map<String, dynamic>>> getResponsesStream(
    String surveyId,
    String questionId,
  ) {
    return _client.getResponsesStream(surveyId, questionId);
  }
}
