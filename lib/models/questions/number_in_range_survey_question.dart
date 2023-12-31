import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:uuid/uuid.dart';

class NumberInRangeSurveyQuestion extends SurveyQuestion {
  NumberInRangeSurveyQuestion._({
    required super.id,
    required super.title,
    required super.description,
    required this.minValue,
    required this.maxValue,
    required this.selectedValue,
  });

  final int minValue;
  final int maxValue;
  late int selectedValue;

  factory NumberInRangeSurveyQuestion.empty() {
    return NumberInRangeSurveyQuestion._(
      id: '${QuestionType.numberInRange.name}-${const Uuid().v4()}',
      title: '',
      description: '',
      minValue: 0,
      maxValue: 100,
      selectedValue: 0,
    );
  }

  factory NumberInRangeSurveyQuestion.fromJson(Map<String, dynamic> json) {
    return NumberInRangeSurveyQuestion._(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      minValue: json['minValue'] as int,
      maxValue: json['maxValue'] as int,
      selectedValue: (json['selectedValue'] ?? json['minValue']) as int,
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
  Map<String, Object> toResponse() {
    final Map<String, Object> data = {};
    data['selectedValue'] = selectedValue;
    return data;
  }

  @override
  String toString() {
    return 'NumberInRange${super.toString()}, minValue: $minValue, maxValue: $maxValue}';
  }
}
