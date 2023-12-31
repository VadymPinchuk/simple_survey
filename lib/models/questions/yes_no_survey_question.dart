import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:uuid/uuid.dart';

class YesNoQuestionKey {
  static const selectedValue = 'selectedValue';
  static const yesValue = 'yesValue';
  static const noValue = 'noValue';
}

class YesNoSurveyQuestion extends SurveyQuestion {
  YesNoSurveyQuestion._({
    required super.id,
    required super.title,
    required super.description,
    required super.isActive,
    required this.selectedValue,
  });

  late bool selectedValue;

  factory YesNoSurveyQuestion.empty() {
    return YesNoSurveyQuestion._(
      id: '${QuestionType.yesNo.name}-${const Uuid().v4()}',
      title: '',
      description: '',
      isActive: true,
      selectedValue: false,
    );
  }

  factory YesNoSurveyQuestion.fromJson(Map<String, dynamic> json) {
    return YesNoSurveyQuestion._(
      id: json['id'] as String,
      title: json[QuestionKey.title] as String,
      description: json[QuestionKey.description] as String,
      isActive: json[QuestionKey.isActive] as bool,
      selectedValue: (json[YesNoQuestionKey.selectedValue] ?? false) as bool,
    );
  }

  @override
  QuestionType get type => QuestionType.yesNo;

  @override
  @override
  Map<String, Object> toResponse() => {
        YesNoQuestionKey.selectedValue: selectedValue,
      };

  @override
  Map<String, dynamic> responsesToStats(List<Map<String, dynamic>> rawData) {
    final positive = rawData.where((element) {
      return element[YesNoQuestionKey.selectedValue] == true;
    }).length;
    final negative = rawData.length - positive;
    return <String, dynamic>{
      QuestionKey.title: title,
      QuestionKey.numOfResponses: rawData.length,
      YesNoQuestionKey.yesValue: positive,
      YesNoQuestionKey.noValue: negative,
    };
  }

  @override
  String toString() => 'YesNo${super.toString()}, '
      '${YesNoQuestionKey.selectedValue}: $selectedValue'
      '}';
}
