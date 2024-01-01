import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/util/uuid_generator.dart';

class CollectionKeys {
  static const String surveys = 'surveys';
  static const String responses = 'responses';
  static const String questions = 'questions';
  static const String respondents = 'respondents';
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

  /// Specific [Survey] doc reference
  DocumentReference<Survey> _surveyDocRef(String surveyId) {
    return FirebaseFirestore.instance
        .doc('${CollectionKeys.surveys}/$surveyId')
        .withConverter<Survey>(
          fromFirestore: (snapshots, _) => Survey.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (survey, _) => survey.toJson(),
        );
  }

  /// Collection of responses
  /// for specific [SurveyQuestion] by its id from [Survey]
  CollectionReference<Map<String, dynamic>> _responsesColRef(
    String surveyId,
    String questionId,
  ) {
    return FirebaseFirestore.instance
        .collection('$surveyId/$questionId/${CollectionKeys.responses}');
  }

  /// FIXME: - review if needed
  DocumentReference<SurveyQuestion> _questionInResponsesDoc(
    String surveyId,
    String questionId,
  ) {
    return FirebaseFirestore.instance
        .doc('$surveyId/$questionId')
        .withConverter<SurveyQuestion>(
          fromFirestore: (snapshots, _) => SurveyQuestion.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (question, _) => question.toJson(),
        );
  }

  /// All respondents collection reference
  CollectionReference<Map<String, dynamic>> _respondentsColRef() {
    return FirebaseFirestore.instance.collection(CollectionKeys.respondents);
  }

  /// Reference to ta document for specific respondent response
  DocumentReference<Map<String, dynamic>> _responseDocRef(
    String surveyId,
    String questionId,
    String respondentId,
  ) {
    return _responsesColRef(surveyId, questionId).doc(respondentId);
  }

  /// Public API to get [Survey]
  Future<Survey> getSurveyById(String surveyId) async {
    var snapshot = await _surveyDocRef(surveyId).get();
    return snapshot.data()!;
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
    await _surveyDocRef(survey.id).set(survey);
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

  /// Public API to save respondent information
  Future<void> saveRespondent(
    Map<String, dynamic> data,
  ) {
    final String uuid = uuidFrom(data);
    return _respondentsColRef().doc(uuid).set(data);
  }

  /// Public API to vote for student by id
  Stream<List<Map<String, dynamic>>> getResponsesStream(
    String surveyId,
    String questionId,
  ) {
    return _responsesColRef(surveyId, questionId).snapshots().map((event) {
      return event.docs.map((e) => e.data()).toList();
    });
  }

  Future<void> _saveQuestionInResponses(
    String surveyId,
    SurveyQuestion question,
  ) async {
    await _questionInResponsesDoc(surveyId, question.id).set(question);
  }

  Future<void> _setQuestionResponse(
    String surveyId,
    String questionId,
    String respondentId,
    Map<String, Object> response,
  ) async {
    await _responseDocRef(surveyId, questionId, respondentId).set(response);
  }
}
