import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:uuid/uuid.dart';

class NumberQuestionKey {
  static const minValue = 'minValue';
  static const maxValue = 'maxValue';
  static const selectedValue = 'selectedValue';
}

class NumberInRangeSurveyQuestion extends SurveyQuestion {
  NumberInRangeSurveyQuestion._({
    required super.id,
    required super.title,
    required super.description,
    required super.isActive,
    required this.minValue,
    required this.maxValue,
    required this.selectedValue,
  });

  final double minValue;
  final double maxValue;
  late double selectedValue;

  factory NumberInRangeSurveyQuestion.empty() {
    return NumberInRangeSurveyQuestion._(
      id: '${QuestionType.numberInRange.name}-${const Uuid().v4()}',
      title: '',
      description: '',
      isActive: true,
      minValue: 0,
      maxValue: 100,
      selectedValue: 0,
    );
  }

  factory NumberInRangeSurveyQuestion.fromJson(Map<String, dynamic> json) {
    return NumberInRangeSurveyQuestion._(
      id: json['id'] as String,
      title: json[QuestionKey.title] as String,
      description: json[QuestionKey.description] as String,
      isActive: json[QuestionKey.isActive] as bool,
      minValue: json[NumberQuestionKey.minValue] as double,
      maxValue: json[NumberQuestionKey.maxValue] as double,
      selectedValue: (json[NumberQuestionKey.selectedValue] ??
          json[NumberQuestionKey.minValue]) as double,
    );
  }

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> data = super.toJson();
    data[NumberQuestionKey.minValue] = minValue;
    data[NumberQuestionKey.maxValue] = maxValue;
    return data;
  }

  @override
  NumberInRangeSurveyQuestion copyWith({String? key, Object? value}) {
    Map<String, Object> json = toJson();
    if (key != null && value != null) {
      json[key] = value;
    }
    return NumberInRangeSurveyQuestion.fromJson(json);
  }

  @override
  QuestionType get type => QuestionType.numberInRange;

  @override
  Map<String, Object> toResponse() {
    final Map<String, Object> data = {};
    data[NumberQuestionKey.selectedValue] = selectedValue;
    return data;
  }

  @override
  String toString() {
    return 'NumberInRange${super.toString()}, '
        '${NumberQuestionKey.minValue}: $minValue, '
        '${NumberQuestionKey.maxValue}: $maxValue, '
        '${NumberQuestionKey.selectedValue}: $selectedValue'
        '}';
  }
}
