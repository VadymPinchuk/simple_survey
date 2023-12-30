import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:simple_survey/constructor/constructor_provider.dart';
import 'package:simple_survey/models/questions/survey_question.dart';

class QuestionEditProvider extends ChangeNotifier {
  QuestionEditProvider(this._constructor);

  final ConstructorProvider _constructor;

  late SurveyQuestion _question;

  SurveyQuestion get question => _question;

  Future<void> editQuestion(SurveyQuestion question) async {
    _question = question.copyWith();
    notifyListeners();
  }

  void setTitle(String title) {
    setParameter('title', title);
  }

  void setDescription(String description) {
    setParameter('description', description);
  }

  void setParameter(String parameter, Object value) {
    _question = _question.copyWith(key: parameter, value: value);
    notifyListeners();
  }

  void saveQuestion() {
    _constructor.changeQuestion(question);
  }
}
