import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:uuid/uuid.dart';

class YesNoQuestionKey {
  static const selectedValue = 'selectedValue';
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
  YesNoSurveyQuestion copyWith({String? key, Object? value}) {
    Map<String, Object> json = toJson();
    if (key != null && value != null) {
      json[key] = value;
    }
    print(json.toString());
    return YesNoSurveyQuestion.fromJson(json);
  }

  @override
  QuestionType get type => QuestionType.yesNo;

  @override
  Map<String, Object> toResponse() {
    final Map<String, Object> data = {};
    data[YesNoQuestionKey.selectedValue] = selectedValue;
    return data;
  }

  @override
  String toString() {
    return 'YesNo${super.toString()}, '
        '${YesNoQuestionKey.selectedValue}: $selectedValue'
        '}';
  }
}
