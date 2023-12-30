import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/constructor_provider.dart';
import 'package:simple_survey/constructor/question/question_edit_dialog.dart';
import 'package:simple_survey/constructor/question/question_edit_provider.dart';
import 'package:simple_survey/models/questions/question_to_widget_transformer.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/widgets/debounced_text_field.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';

class ConstructorScreen extends StatefulWidget {
  const ConstructorScreen({
    super.key,
    // required this.surveyId,
  });

  // final String surveyId;

  @override
  State<StatefulWidget> createState() => _ConstructorScreenState();
}

class _ConstructorScreenState extends State<ConstructorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Constructor'),
        actions: [
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
      body: Selector<ConstructorProvider, Survey>(
        selector: (_, provider) => provider.survey,
        builder: (BuildContext context, Survey survey, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                DebouncedTextField(
                  text: survey.title,
                  labelText: 'Survey Title',
                  onChanged: context.read<ConstructorProvider>().setTitle,
                ),
                const SizedBox(height: 8),
                DebouncedTextField(
                  text: survey.description,
                  labelText: 'Survey short description',
                  maxLines: 2,
                  onChanged: context.read<ConstructorProvider>().setDescription,
                ),
                Expanded(
                  child: survey.questions.isEmpty
                      ? const Center(child: Text('No items added yet.'))
                      : ListView.builder(
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
        onPressed: () => _showBottomSheet(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addQuestion(SurveyQuestion question) {
    context.read<ConstructorProvider>().changeQuestion(question);
    context.pop(); // Close the bottom sheet
    context.read<QuestionEditProvider>().editQuestion(question);
    showDialog(
      context: context,
      builder: (BuildContext context) => const QuestionEditDialog(),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final availableQuestions = getAvailableQuestions();
        return ListView.builder(
          itemCount: availableQuestions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(availableQuestions[index].name),
              onTap: () {
                _addQuestion(availableQuestions[index].toSurveyQuestion());
              },
            );
          },
        );
      },
    );
  }

  List<QuestionType> getAvailableQuestions() => QuestionType.values;
}
