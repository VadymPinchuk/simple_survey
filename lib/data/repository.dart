import 'package:simple_survey/data/firebase_client.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/models/vote.dart';

class Repository {
  Repository() {
    _client = FirebaseClient();
  }

  late FirebaseClient _client;

  Future<Survey?> getSurveyById(String surveyId) async {
    return await _client.getSurveyById(surveyId);
  }

  Future<List<Survey>> getSurveysList() {
    return _client.getSurveysList();
  }

  Stream<List<Survey>> get streamOfSurveys => _client.getSurveysStream();

  Future<void> createOrUpdateSurvey(Survey survey) async {
    if (survey.id.isEmpty) {
      await _client.createSurvey(survey);
    } else {
      await _client.updateSurvey(survey);
    }
  }

  void sendVote(String studentId, Vote vote) {
    _client.voteFor(studentId, vote);
  }

  Stream<List<Vote>> getVotesStream(String studentId) {
    return _client.getVotesStream(studentId);
  }
}
