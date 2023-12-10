import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/data/student.dart';

class ChartProvider extends ChangeNotifier {
  ChartProvider(this._repository);

  final Repository _repository;

  List<Student> _students = List.empty();

  List<Student> get students => _students;
  final List<StreamSubscription> _subscriptions = List.empty(growable: true);

  Future<void> requestStudents() async {
    _students = await _repository.getStudentsList();
    for (Student each in _students) {
      _subscriptions.add(getStudentScoreStream(each.id).listen((score) {
        Student newStudent = _students
            .firstWhere((first) => first.id == each.id)
            .copyWith(score);
        _students
          ..removeWhere((student) => student.id == newStudent.id)
          ..add(newStudent);
        _students = List.from(students);
        notifyListeners();
      }));
    }
    notifyListeners();
  }

  Stream<double> getStudentScoreStream(String studentId) {
    return _repository.getVotesStream(studentId).map((list) {
      var sum = list.fold(0.0, (prev, curr) {
        return prev + curr.voteAverage;
      });
      // TEST ONLY (With my scores)
      if (list.length == 1) return sum;
      // Removing one participant with empty scores (me)
      return sum / list.length - 1;
    });
  }

  String createInitials(String fullName) {
    List<String> names = fullName.split(' '); // Split the string by spaces
    String initials = '';

    for (String name in names) {
      if (name.isNotEmpty) {
        initials += name[0]
            .toUpperCase(); // Take the first character of each part and capitalize it
      }
    }
    return initials;
  }

  @override
  void dispose() {
    for (var element in _subscriptions) {
      element.cancel();
    }
    super.dispose();
  }
}
