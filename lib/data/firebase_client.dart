import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/survey.dart';

class CollectionKeys {
  static const String surveys = 'surveys';
  static const String responses = 'responses';
  static const String questions = 'questions';
}

class FirebaseClient {
  /// A reference to the list of created surveys
  /// We are using `withConverter` to ensure
  /// that interactions with the collection are type-safe.
  final _surveysRef = FirebaseFirestore.instance
      .collection(CollectionKeys.surveys)
      .withConverter<Survey>(
        fromFirestore: (snapshots, _) => Survey.fromJson(
          snapshots.data()!,
        ),
        toFirestore: (survey, _) => survey.toJson(),
      );

  DocumentReference<Survey> _surveyDoc(String surveyId) {
    return FirebaseFirestore.instance
        .doc('${CollectionKeys.surveys}/$surveyId')
        .withConverter<Survey>(
          fromFirestore: (snapshots, _) => Survey.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (survey, _) => survey.toJson(),
        );
  }

  DocumentReference<Survey> _surveyCollection(String surveyId) {
    return FirebaseFirestore.instance
        .doc('${CollectionKeys.responses}/$surveyId')
        .withConverter<Survey>(
          fromFirestore: (snapshots, _) => Survey.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (survey, _) => survey.toJson(),
        );
  }

  DocumentReference<SurveyQuestion> _questionResponsesDoc(
    String surveyID,
    String questionID,
  ) {
    return FirebaseFirestore.instance
        .doc('$surveyID/$questionID')
        .withConverter<SurveyQuestion>(
          fromFirestore: (snapshots, _) => SurveyQuestion.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (question, _) => question.toJson(),
        );
  }

  DocumentReference<Map<String, dynamic>> _questionResponseDoc(
    String surveyId,
    String questionId,
    String respondentId,
  ) {
    return FirebaseFirestore.instance
        .doc('$surveyId/$questionId/${CollectionKeys.responses}/$respondentId');
    // .withConverter<SurveyQuestion>(
    //   fromFirestore: (snapshots, _) => SurveyQuestion.fromJson(
    //     snapshots.data()!,
    //   ),
    //   toFirestore: (question, _) => question.toJson(),
    // );
  }

  /// Public API to get all created surveys as a List or Stream

  Future<Survey?> getSurveyById(String surveyId) async {
    var snapshot = await _surveyDoc(surveyId).get();
    return snapshot.data();
  }

  Future<List<Survey>> getSurveysList() async {
    var snapshot = await _surveysRef.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  Stream<List<Survey>> getSurveysStream() {
    return _surveysRef.snapshots().map((event) {
      return event.docs.map((e) => e.data()).toList();
    });
  }

  /// Public API to create new Survey record
  Future<void> createSurvey(Survey survey) async {
    final doc = await _surveysRef.add(survey);
    updateSurvey(survey.copyWith(id: doc.id));
  }

  /// Public API to update existing Survey record
  Future<void> updateSurvey(Survey survey) async {
    await _surveyDoc(survey.id).set(survey);
    for (var question in survey.questions) {
      await _saveQuestionInResponses(survey.id, question);
    }
  }

  /// Public API to send survey responses by each respondent
  Future<void> sendResponse(String respondentId, Survey survey) async {
    for (var question in survey.questions) {
      final response = question.toResponse();
      await _setQuestionResponse(
          survey.id, question.id, respondentId, response);
    }
  }

  Future<void> _saveQuestionInResponses(
    String surveyId,
    SurveyQuestion question,
  ) async {
    await _questionResponsesDoc(surveyId, question.id).set(question);
  }

  Future<void> _setQuestionResponse(
    String surveyId,
    String questionId,
    String respondentId,
    Map<String, Object> response,
  ) async {
    await _questionResponseDoc(surveyId, questionId, respondentId)
        .set(response);
  }

  /// Public API to vote for student by id
// Stream<List<Vote>> getVotesStream(String studentId) {
//   return _questionResponsesRef(studentId).snapshots().map((event) {
//     return event.docs.map((e) => e.data()).toList();
//   });
// }
}
