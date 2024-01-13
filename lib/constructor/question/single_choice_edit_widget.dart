import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/question/question_edit_provider.dart';
import 'package:simple_survey/models/questions/single_choice_survey_question.dart';
import 'package:simple_survey/widgets/debounced/debounced_text_field.dart';

class SingleChoiceEditWidget extends StatelessWidget {
  const SingleChoiceEditWidget({
    super.key,
    required this.question,
  });

  final SingleChoiceSurveyQuestion question;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...question.options.map(
          (option) => ListTile(
            leading: Radio<int>(
              value: option.id,
              groupValue: question.selectedId,
              onChanged: (newIndex) {
                final list = question.options;
                if (question.selectedId != -1) {
                  final oldSelection =
                      list.removeAt(question.selectedId).copyWith(isSelected: false);
                  list.insert(question.selectedId, oldSelection);
                }
                final newSelection = list.removeAt(newIndex!).copyWith(isSelected: true);
                list.insert(newIndex, newSelection);
                context.read<QuestionEditProvider>()
                  ..setParameter(SingleChoiceQuestionKey.options, list)
                  ..setParameter(SingleChoiceQuestionKey.selectedId, newIndex);
              },
            ),
            title: DebouncedTextField(
                text: option.label,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                onChanged: (label) {
                  final list = question.options;
                  final newSelection = list.removeAt(option.id).copyWith(label: label);
                  list.insert(option.id, newSelection);
                  context
                      .read<QuestionEditProvider>()
                      .setParameter(SingleChoiceQuestionKey.options, list);
                }),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Option'),
          onPressed: () {
            question.options.add(SingleChoiceOption.empty(question.options.length));
            context
                .read<QuestionEditProvider>()
                .setParameter(SingleChoiceQuestionKey.options, question.options);
          },
        ),
      ],
    );
  }
}
