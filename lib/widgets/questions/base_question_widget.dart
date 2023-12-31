import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/constructor_screen.dart';
import 'package:simple_survey/constructor/question/question_edit_dialog.dart';
import 'package:simple_survey/constructor/question/question_edit_provider.dart';
import 'package:simple_survey/models/questions/survey_question.dart';

enum QuestionMode { edit, submit }

/// Widget with basic UI - title and description
abstract class BaseQuestionWidget<T extends SurveyQuestion> extends StatelessWidget {
  const BaseQuestionWidget({
    super.key,
    required this.question,
    required this.mode,
    this.onChanged,
  });

  final T question;
  final QuestionMode mode;

  final Function(SurveyQuestion)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final text = Theme.of(context).textTheme;
    final primary = theme.colorScheme.primary.withOpacity(0.5);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        surfaceTintColor: Colors.transparent,
        shadowColor: primary,
        color: (question.isActive ? cardColor : Colors.grey).withOpacity(0.7),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question.title,
                      style: text.titleMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (mode == QuestionMode.edit) _questionsActivity(context),
                  if (mode == QuestionMode.edit) _editButton(context),
                ],
              ),
              if (question.description.isNotEmpty)
                Text(question.description, style: text.bodyMedium),
              childSpecificUI(context),
            ],
          ),
        ),
      ),
    );
  }

  /// UI specific to each child implementation:
  /// Slider, RangeSlider, Number, ets
  Widget childSpecificUI(BuildContext context);

  /// Edit button is enabled in [ConstructorScreen]
  Widget _questionsActivity(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        question.isActive ? 'Active' : 'Inactive',
      ),
    );
  }

  /// Edit button is enabled in [ConstructorScreen]
  Widget _editButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        context.read<QuestionEditProvider>().editQuestion(question);
        showDialog(
          context: context,
          builder: (BuildContext context) => const QuestionEditDialog(),
        );
      },
    );
  }
}
