import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/question/question_edit_provider.dart';
import 'package:simple_survey/models/questions/number_in_range_survey_question.dart';
import 'package:simple_survey/widgets/debounced_range_slider.dart';
import 'package:simple_survey/widgets/debounced_text_field.dart';

class QuestionEditDialog extends StatefulWidget {
  const QuestionEditDialog({super.key});

  @override
  State<StatefulWidget> createState() => _QuestionEditDialogState();
}

class _QuestionEditDialogState extends State<QuestionEditDialog> {
  @override
  void didChangeDependencies() {
    // final question = context.read<QuestionEditProvider>().question;
    // if (question is SingleNumberSurveyQuestion) {
    //   SingleNumberSurveyQuestion singleNumberQuestion =
    //       question;
    //   _rangeValues = RangeValues(singleNumberQuestion.minValue.toDouble(),
    //       singleNumberQuestion.maxValue.toDouble());
    // }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final question = context.read<QuestionEditProvider>().question;
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('Edit Question'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: DebouncedTextField(
                  text: question.title,
                  labelText: 'Title',
                  onChanged: context.read<QuestionEditProvider>().setTitle,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: DebouncedTextField(
                  text: question.description,
                  labelText: 'Description',
                  maxLines: 3,
                  onChanged:
                      context.read<QuestionEditProvider>().setDescription,
                ),
              ),
              if (question is NumberInRangeSurveyQuestion) _buildRangeSlider(),
              // Add other widgets for different question types here
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              if (context.read<QuestionEditProvider>().isQuestionFilled()) {
                context.read<QuestionEditProvider>().saveQuestion();
                context.pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Title and description can\'t be empty'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSlider() {
    final question = context.read<QuestionEditProvider>().question
        as NumberInRangeSurveyQuestion;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DebouncedRangeSlider(
        values: RangeValues(
          question.minValue.toDouble(),
          question.maxValue.toDouble(),
        ),
        min: 0,
        max: 100,
        // Set appropriate range
        onChanged: (RangeValues values) {
          context.read<QuestionEditProvider>()
            ..setParameter('minValue', values.start.round())
            ..setParameter('maxValue', values.end.round());
        },
      ),
    );
  }
}
