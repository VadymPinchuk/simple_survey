import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/constructor_screen.dart';
import 'package:simple_survey/constructor/question/question_edit_dialog.dart';
import 'package:simple_survey/constructor/question/question_edit_provider.dart';
import 'package:simple_survey/models/questions/survey_question.dart';

enum QuestionMode { edit, submit }

/// Widget with basic UI - title and description
abstract class BaseQuestionWidget<T extends SurveyQuestion>
    extends StatelessWidget {
  const BaseQuestionWidget(
    this.question,
    this.mode, {
    super.key,
  });

  final T question;
  final QuestionMode mode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question.title,
                      style: theme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (mode == QuestionMode.edit) _editButton(context),
                ],
              ),
              Text(question.description, style: theme.bodyMedium),
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
