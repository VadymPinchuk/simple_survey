import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';

abstract class SurveyQuestion {
  SurveyQuestion({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;
  final String title;
  final String description;

  QuestionType get type;

  static SurveyQuestion fromJson(Map<String, dynamic> json) {
    QuestionType type = QuestionType.fromString(json['type']);

    switch (type) {
      case QuestionType.numberInRange:
        return NumberInRangeSurveyQuestion.fromJson(json);
      // case QuestionType.singleChoice:
      //   return SingleChoiceSurveyQuestion.fromJson(json);
      // case QuestionType.multipleChoice:
      //   return MultipleChoiceSurveyQuestion.fromJson(json);
      default:
        throw Exception('Unknown QuestionType: $type');
    }
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
    };
  }

  SurveyQuestion copyWith({String? key, Object? value});

  @override
  String toString() =>
      'SurveyQuestion{id: $id, title: $title, description: $description, type: ${type.name}}';
}

enum QuestionType {
  numberInRange('numberInRange');
  // singleChoice('singleChoice'),
  // multipleChoices('multipleChoices'),
  // freeFormText('freeFormText');

  final String name;

  const QuestionType(this.name);

  static QuestionType fromString(String name) {
    return QuestionType.values.firstWhere((element) => element.name == name);
  }

  SurveyQuestion toSurveyQuestion() {
    return switch (this) {
      QuestionType.numberInRange => NumberInRangeSurveyQuestion.empty(),
      _ => NumberInRangeSurveyQuestion.empty(),
    };
  }
}
