import 'package:flutter/widgets.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:uuid/uuid.dart';

class SingleChoiceQuestionKey {
  static const options = 'options';
  static const selectedId = 'selectedId';
}

/// Data class for the [SurveyQuestion] with single possible selected option
@immutable
class SingleChoiceSurveyQuestion extends SurveyQuestion {
  SingleChoiceSurveyQuestion._({
    required super.id,
    required super.title,
    required super.description,
    required super.isActive,
    required this.options,
    required this.selectedId,
  });

  final List<SingleChoiceOption> options;
  final int selectedId;

  factory SingleChoiceSurveyQuestion.empty() {
    return SingleChoiceSurveyQuestion._(
      id: '${QuestionType.singleChoice.name}-${const Uuid().v4()}',
      title: '',
      description: '',
      isActive: true,
      options: List<SingleChoiceOption>.empty(growable: true),
      selectedId: -1,
    );
  }

  factory SingleChoiceSurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SingleChoiceSurveyQuestion._(
      id: json['id'] as String,
      title: json[QuestionKey.title] as String,
      description: json[QuestionKey.description] as String,
      isActive: json[QuestionKey.isActive] as bool,
      options: (json[SingleChoiceQuestionKey.options] as List).map((jsonItem) {
        return SingleChoiceOption.fromJson(jsonItem);
      }).toList(),
      selectedId: json[SingleChoiceQuestionKey.selectedId] as int? ?? -1,
    );
  }

  @override
  Map<String, Object> toJson() {
    return super.toJson()
      ..putIfAbsent(SingleChoiceQuestionKey.options, () => options.toJson())
      ..putIfAbsent(SingleChoiceQuestionKey.selectedId, () => selectedId);
  }

  @override
  SingleChoiceSurveyQuestion copyWith(Map<String, Object>? changes) {
    Map<String, Object> json = toJson();
    changes?.entries.forEach((entry) {
      final value = entry.value;
      json[entry.key] = value is List<SingleChoiceOption> ? value.toJson() : value;
    });
    return SingleChoiceSurveyQuestion.fromJson(json);
  }

  @override
  QuestionType get type => QuestionType.singleChoice;

  @override
  @override
  Map<String, Object> toResponse() => {
        SingleChoiceQuestionKey.selectedId: selectedId,
      };

  @override
  Map<String, dynamic> responsesToStats(List<Map<String, dynamic>> rawData) {
    // init
    List<int> counts = List.filled(options.length, 0);
    // count and fill
    for (var item in rawData) {
      for (var id in item.values) {
        counts[id] += 1;
      }
    }
    Map answersMap = <String, Object>{}..addEntries(
        options.map((e) => MapEntry(e.label, counts[e.id])),
      );

    return <String, dynamic>{
      QuestionKey.title: title,
      QuestionKey.numOfResponses: rawData.length,
      SingleChoiceQuestionKey.options: answersMap,
    };
  }

  @override
  String toString() => 'SingleChoice${super.toString()}, '
      '${SingleChoiceQuestionKey.selectedId}: $selectedId'
      '${SingleChoiceQuestionKey.options}: ${options.toString()}'
      '}';
}

/// Data class for single option
@immutable
class SingleChoiceOption {
  const SingleChoiceOption._({
    required this.id,
    required this.label,
    this.isSelected = false,
  });

  factory SingleChoiceOption.empty(int id) {
    return SingleChoiceOption._(
      id: id,
      label: 'Option $id',
      isSelected: false,
    );
  }

  final int id;
  final String label;
  final bool isSelected;

  // If you need to create a copy of this object with modified fields, you can add a copyWith method:
  SingleChoiceOption copyWith({
    int? id,
    bool? isSelected,
    String? label,
  }) {
    return SingleChoiceOption._(
      id: id ?? this.id,
      isSelected: isSelected ?? this.isSelected,
      label: label ?? this.label,
    );
  }

  // If you need to convert this object to and from JSON, you can add toJson and fromJson methods:
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isSelected': isSelected,
      'label': label,
    };
  }

  factory SingleChoiceOption.fromJson(Map<String, dynamic> json) {
    return SingleChoiceOption._(
      id: json['id'] as int,
      isSelected: json['isSelected'] as bool? ?? false,
      label: json['label'] as String,
    );
  }

  @override
  String toString() {
    return 'SingleChoiceOption{id: $id, isSelected: $isSelected, label: $label}';
  }
}

/// Extension for easy encoding
extension ListToJson on List<SingleChoiceOption> {
  List<Map<String, dynamic>> toJson() {
    return map((option) => option.toJson()).toList();
  }
}
