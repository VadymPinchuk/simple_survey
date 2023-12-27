import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/models/student.dart';
import 'package:simple_survey/models/vote.dart';
import 'package:simple_survey/util/device_data.dart';

typedef Score = ({String id, double score, double current});

class SurveyProvider extends ChangeNotifier {
  SurveyProvider(this._repository);

  final Repository _repository;

  List<Student> _students = List.empty();

  List<Student> get students => _students;
  Student? _current;
  double _voteIdea = 0.0;

  double get voteIdea => _voteIdea;

  double _votePresentation = 0.0;

  double get votePresentation => _votePresentation;

  double _voteImplementation = 0.0;

  double get voteImplementation => _voteImplementation;

  double _voteAverage = 0;

  double get voteAverage => _voteAverage;

  Map<String, dynamic> _deviceData = <String, dynamic>{};

  bool _isReadyToVote = false;

  bool get isReadyToVote => _isReadyToVote;

  Future<void> requestStudents() async {
    // _students = await _repository.getSurveysList();

    // FOR TEST PURPOSES ONLY:
    // _sentEmptyVote();

    _deviceData = await readPlatformData();
    notifyListeners();
  }

  void _sentEmptyVote() {
    for (Student student in _students) {
      _repository.sendVote(
        student.id,
        Vote(
          voterId: 'Vadym Pinchuk',
          studentId: student.id,
          voteIdea: 0,
          votePresentation: 0,
          voteImplementation: 0,
          voteAverage: 0,
        ),
      );
    }
  }

  void selectStudent(Student student) {
    _current = student;
    _checkIfReadyToSend();
    notifyListeners();
  }

  void changeScore(
      {double? idea, double? presentation, double? implementation}) {
    _voteIdea = idea ?? _voteIdea;
    _votePresentation = presentation ?? _votePresentation;
    _voteImplementation = implementation ?? _voteImplementation;
    _voteAverage = (_voteIdea + _votePresentation + _voteImplementation) / 3;
    _checkIfReadyToSend();
    notifyListeners();
  }

  void _checkIfReadyToSend() {
    _isReadyToVote = _current != null &&
        _voteIdea > 0.0 &&
        _votePresentation > 0.0 &&
        _voteImplementation > 0.0 &&
        _voteAverage > 0.0;
  }

  void sendVote() {
    _repository.sendVote(
      _current!.id,
      Vote(
        voterId: _deviceData.toString().hashCode.toString(),
        studentId: _current!.id,
        voteIdea: _voteIdea,
        votePresentation: _votePresentation,
        voteImplementation: _voteImplementation,
        voteAverage: _voteAverage.roundToDouble(),
      ),
    );
    _students = List.from(_students)
      ..removeWhere((element) => element.id == _current!.id);
    _voteIdea = 0;
    _votePresentation = 0;
    _voteImplementation = 0;
    _voteAverage = 0;
    _current = null;
    _checkIfReadyToSend();
    notifyListeners();
  }
}
