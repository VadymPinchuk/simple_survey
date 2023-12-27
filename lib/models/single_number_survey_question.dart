import 'package:simple_survey/models/survey_question.dart';

class SingleNumberSurveyQuestion extends SurveyQuestion {
  final int minValue;
  final int maxValue;
  late int selectedValue;

  SingleNumberSurveyQuestion._({
    required super.id,
    required super.title,
    required super.description,
    required this.minValue,
    required this.maxValue,
  });

  factory SingleNumberSurveyQuestion.empty() {
    return SingleNumberSurveyQuestion._(
      id: DateTime.now().toString(),
      title: '',
      description: '',
      minValue: 0,
      maxValue: 100,
    );
  }

  factory SingleNumberSurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SingleNumberSurveyQuestion._(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      minValue: json['minValue'] as int,
      maxValue: json['maxValue'] as int,
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
  SingleNumberSurveyQuestion copyWith({
    String? id,
    String? title,
    String? description,
    int? minValue,
    int? maxValue,
  }) {
    return SingleNumberSurveyQuestion._(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
    );
  }

  @override
  QuestionType get type => QuestionType.singleNumber;

  @override
  String toString() {
    return 'Checked${super.toString()}, minValue: $minValue, maxValue: $maxValue}';
  }
}
