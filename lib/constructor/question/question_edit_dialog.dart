import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/question/question_edit_provider.dart';
import 'package:simple_survey/constructor/question/single_choice_edit_widget.dart';
import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';
import 'package:simple_survey/models/questions/single_choice_survey_question.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/questions/yes_no_survey_question.dart';
import 'package:simple_survey/widgets/debounced/debounced_range_slider.dart';
import 'package:simple_survey/widgets/debounced/debounced_text_field.dart';

class QuestionEditDialog extends StatefulWidget {
  const QuestionEditDialog({super.key});

  @override
  State<StatefulWidget> createState() => _QuestionEditDialogState();
}

class _QuestionEditDialogState extends State<QuestionEditDialog> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      child: SizedBox(
        width: double.infinity,
        child: AlertDialog(
          title: Text(
            'Edit Question',
            style: textTheme.headlineMedium,
          ),
          actionsPadding: const EdgeInsets.all(8.0),
          actions: [
            TextButton(
              child: Text(
                'Save',
                style: textTheme.bodyLarge!.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              onPressed: () {
                final provider = context.read<QuestionEditProvider>();
                if (provider.isQuestionFilled()) {
                  provider.saveQuestion();
                  context.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title can\'t be empty'),
                    ),
                  );
                }
              },
            ),
          ],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 8),
          content: Selector<QuestionEditProvider, SurveyQuestion>(
            selector: (_, provider) => provider.question,
            builder: (_, question, __) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: DebouncedTextField(
                              text: question.title,
                              labelText: 'Title',
                              onChanged: context.read<QuestionEditProvider>().setTitle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Switch(
                          value: question.isActive,
                          onChanged: context.read<QuestionEditProvider>().setActiveStatus,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: DebouncedTextField(
                        text: question.description,
                        labelText: 'Description (optional)',
                        maxLines: 1,
                        onChanged: context.read<QuestionEditProvider>().setDescription,
                      ),
                    ),
                    _questionTypeSpecificUI(question),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _questionTypeSpecificUI(SurveyQuestion question) {
    if (question is NumberInRangeSurveyQuestion) {
      return _buildRangeSlider(question);
    }
    if (question is YesNoSurveyQuestion) {
      return _buildYesNoSwitch(question);
    }
    if (question is SingleChoiceSurveyQuestion) {
      return SingleChoiceEditWidget(question: question);
    }
    return const SizedBox.shrink();
  }

  Widget _buildRangeSlider(NumberInRangeSurveyQuestion question) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: DebouncedRangeSlider(
        values: RangeValues(
          question.minValue,
          question.maxValue,
        ),
        min: 0.0,
        max: 100.0,
        // Set appropriate range
        onChanged: (RangeValues values) {
          context.read<QuestionEditProvider>()
            ..setParameter(NumberQuestionKey.minValue, values.start)
            ..setParameter(NumberQuestionKey.maxValue, values.end);
        },
      ),
    );
  }

  Widget _buildYesNoSwitch(YesNoSurveyQuestion question) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('NO'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Switch(
              value: question.selectedValue,
              onChanged: (value) {},
            ),
          ),
          const Text('YES'),
        ],
      ),
    );
  }
}
