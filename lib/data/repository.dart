import 'package:simple_survey/data/firebase_client.dart';
import 'package:simple_survey/data/student.dart';
import 'package:simple_survey/data/vote.dart';

class Repository {
  Repository() {
    _client = FirebaseClient();
  }

  late FirebaseClient _client;

  Future<List<Student>> getStudentsList() async {
    List<Student> students = await _client.getStudentsList();
    return students;
  }

  void sendVote(String studentId, Vote vote) {
    _client.voteFor(studentId, vote);
  }

  Stream<List<Vote>> getVotesStream(String studentId) {
    return _client.getVotesStream(studentId);
  }
}
