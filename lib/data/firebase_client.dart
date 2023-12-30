import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/models/vote.dart';

class FirebaseCollections {
  static const String surveys = 'surveys';
  static const String responses = 'responses';
}

class FirebaseClient {
  /// A reference to the list of created surveys
  /// We are using `withConverter` to ensure
  /// that interactions with the collection are type-safe.
  final _surveysRef =
      FirebaseFirestore.instance.collection(FirebaseCollections.surveys).withConverter<Survey>(
            fromFirestore: (snapshots, _) => Survey.fromJson(
              snapshots.data()!,
            ),
            toFirestore: (survey, _) => survey.toJson(),
          );

  DocumentReference<Survey> _surveyDoc(String surveyId) {
    return FirebaseFirestore.instance
        .doc('${FirebaseCollections.surveys}/$surveyId')
        .withConverter<Survey>(
          fromFirestore: (snapshots, _) => Survey.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (survey, _) => survey.toJson(),
        );
  }

  CollectionReference<Vote> _votingCollectionRef(String studentId) {
    return FirebaseFirestore.instance
        .collection('students/$studentId/votes')
        .withConverter<Vote>(
          fromFirestore: (snapshots, _) => Vote.fromJson(
            snapshots.id,
            snapshots.data()!,
          ),
          toFirestore: (vote, _) => vote.toJson(),
        );
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
    await _surveyDoc(survey.id).update(survey.toJson());
  }

  /// Public API to vote for student by id
  void voteFor(String studentId, Vote vote) {
    _votingCollectionRef(studentId).add(vote);
  }

  Stream<List<Vote>> getVotesStream(String studentId) {
    return _votingCollectionRef(studentId).snapshots().map((event) {
      return event.docs.map((e) => e.data()).toList();
    });
  }
}
