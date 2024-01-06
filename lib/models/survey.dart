import 'package:simple_survey/models/questions/survey_question.dart';

class Survey {
  final String id;
  final String title;
  final String description;
  final bool isActive;
  final List<SurveyQuestion> questions;
  final String lastUpdate;

  Survey._({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.questions,
    required this.lastUpdate,
  });

  factory Survey.empty() {
    return Survey._(
      id: '',
      title: '',
      description: '',
      isActive: true,
      questions: List.empty(growable: true),
      lastUpdate: DateTime.now().toIso8601String(),
    );
  }

  factory Survey.fromJson(Map<String, dynamic> json) {
    var questionList = json['questions'] as List;
    List<SurveyQuestion> questions =
        questionList.map((i) => SurveyQuestion.fromJson(i as Map<String, dynamic>)).toList();

    return Survey._(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isActive: json['isActive'],
      questions: questions,
      lastUpdate: json['lastUpdate'],
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isActive': isActive,
      'questions': questions.map((q) => q.toJson()).toList(),
      'lastUpdate': lastUpdate,
    };
  }

  Survey copyWith({
    String? id,
    String? title,
    String? description,
    bool? isActive,
    List<SurveyQuestion>? questions,
  }) {
    return Survey._(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      questions: questions ?? this.questions,
      lastUpdate: DateTime.now().toIso8601String(),
    );
  }

  String titleToPascalCase() {
    return title
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
        .join();
  }

  @override
  String toString() {
    return 'Survey { $id, $title, ${questions.where((element) => element.isActive).length}, $lastUpdate}';
  }
}
