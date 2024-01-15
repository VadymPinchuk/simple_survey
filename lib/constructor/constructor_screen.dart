import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/constructor_provider.dart';
import 'package:simple_survey/constructor/question/question_edit_dialog.dart';
import 'package:simple_survey/constructor/question/question_edit_provider.dart';
import 'package:simple_survey/models/questions/question_to_widget_transformer.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/widgets/debounced/debounced_text_field.dart';
import 'package:simple_survey/widgets/loader.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';

/// Survey creation / edition screen
/// Enables user to modify main parts of the survey
class ConstructorScreen extends StatefulWidget {
  const ConstructorScreen({super.key, required this.surveyId});

  final String surveyId;

  @override
  State<ConstructorScreen> createState() => _ConstructorScreenState();
}

class _ConstructorScreenState extends State<ConstructorScreen> {
  @override
  void didChangeDependencies() {
    context.read<ConstructorProvider>().selectSurvey(widget.surveyId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Constructor'),
        actions: [
          Selector<ConstructorProvider, String?>(
              selector: (_, provider) => provider.survey?.id,
              builder: (_, String? surveyId, __) {
                if (surveyId?.isEmpty == true) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    await context.read<ConstructorProvider>().deleteSurvey().then(
                          (value) => context.pop(),
                        );
                  },
                );
              }),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await context.read<ConstructorProvider>().saveSurvey().then(
                    (value) => context.pop(),
                  );
            },
          ),
        ],
      ),
      body: Selector<ConstructorProvider, Survey?>(
        selector: (_, provider) => provider.survey,
        builder: (_, Survey? survey, __) {
          if (survey == null) return const Loader();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8.0),
                DebouncedTextField(
                  text: survey.title,
                  labelText: 'Survey Title',
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  onChanged: context.read<ConstructorProvider>().setTitle,
                ),
                const SizedBox(height: 12.0),
                DebouncedTextField(
                  text: survey.description,
                  labelText: 'Survey short description',
                  maxLines: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  onChanged: context.read<ConstructorProvider>().setDescription,
                ),
                Expanded(
                  child: survey.questions.isEmpty
                      ? const Center(child: Text('No items added yet.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          itemCount: survey.questions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return survey.questions[index]
                                .toQuestionWidget(mode: QuestionMode.edit);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addQuestion(BuildContext context, SurveyQuestion question) {
    context.read<ConstructorProvider>().changeQuestion(question);
    context.pop(); // Close the bottom sheet
    context.read<QuestionEditProvider>().editQuestion(question);
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuestionEditDialog(),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final availableQuestions = getAvailableQuestions();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Add question to survey',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: availableQuestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(availableQuestions[index].readableName),
                    onTap: () {
                      _addQuestion(
                        context,
                        availableQuestions[index].toSurveyQuestion(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<QuestionType> getAvailableQuestions() => QuestionType.values;
}
