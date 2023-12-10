import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_survey/data/student.dart';
import 'package:simple_survey/data/vote.dart';

class FirebaseClient {
  /// A reference to the list of students
  /// We are using `withConverter` to ensure
  /// that interactions with the collection are type-safe.
  final _studentsRef =
      FirebaseFirestore.instance.collection('students').withConverter<Student>(
            fromFirestore: (snapshots, _) => Student.fromJson(
              snapshots.id,
              snapshots.data()!,
            ),
            toFirestore: (student, _) => student.toJson(),
          );

  CollectionReference<Vote> _votingCollectionRef(String studentId) {
    return FirebaseFirestore.instance.collection('students/$studentId/votes').withConverter<Vote>(
          fromFirestore: (snapshots, _) => Vote.fromJson(
            snapshots.id,
            snapshots.data()!,
          ),
          toFirestore: (vote, _) => vote.toJson(),
        );
  }

  /// Public API to get all students list
  Future<List<Student>> getStudentsList() async {
    var snapshot = await _studentsRef.get();
    return snapshot.docs.map((e) => e.data()).toList();
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
