import 'package:simple_survey/models/survey_question.dart';

class NumberInRangeSurveyQuestion extends SurveyQuestion {
  NumberInRangeSurveyQuestion._({
    required super.id,
    required super.title,
    required super.description,
    required this.minValue,
    required this.maxValue,
  });

  final double minValue;
  final double maxValue;
  late double selectedValue = minValue;

  factory NumberInRangeSurveyQuestion.empty() {
    return NumberInRangeSurveyQuestion._(
      id: '${QuestionType.numberInRange.name} ${DateTime.now().toIso8601String()}',
      title: '',
      description: '',
      minValue: 0,
      maxValue: 100,
    );
  }

  factory NumberInRangeSurveyQuestion.fromJson(Map<String, dynamic> json) {
    return NumberInRangeSurveyQuestion._(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      minValue: json['minValue'] as double,
      maxValue: json['maxValue'] as double,
    );
  }

  @override
  Map<String, Object> toJson() {
    final Map<String, Object> data = super.toJson();
    data['minValue'] = minValue;
    data['maxValue'] = maxValue;
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
  String toString() {
    return 'NumberInRange${super.toString()}, minValue: $minValue, maxValue: $maxValue}';
  }
}
