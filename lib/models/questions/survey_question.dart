import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';

class QuestionKey {
  static const title = 'title';
  static const description = 'description';
  static const isActive = 'isActive';
  static const type = 'type';
}

abstract class SurveyQuestion {
  SurveyQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
  });

  final String id;
  final String title;
  final String description;
  final bool isActive;

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
      QuestionKey.title: title,
      QuestionKey.description: description,
      QuestionKey.isActive: isActive,
      QuestionKey.type: type.name,
    };
  }

  SurveyQuestion copyWith({String? key, Object? value});

  Map<String, Object> toResponse();

  @override
  String toString() => 'SurveyQuestion{'
      'id: $id, '
      '${QuestionKey.title}: $title, '
      '${QuestionKey.description}: $description, '
      '${QuestionKey.isActive}: $isActive, '
      '${QuestionKey.type}: ${type.name}'
      '}';
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
