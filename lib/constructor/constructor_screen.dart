import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/constructor_provider.dart';
import 'package:simple_survey/models/question_to_widget_transformer.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/models/survey_question.dart';

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
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;

  void _addQuestion(SurveyQuestion question) {
    context.read<ConstructorProvider>().changeQuestion(question);
    Navigator.pop(context); // Close the bottom sheet
  }

  @override
  void didChangeDependencies() {
    final Survey survey = context.read<ConstructorProvider>().survey;
    _titleController =
        _titleController ?? TextEditingController(text: survey.title);
    _descriptionController = _descriptionController ??
        TextEditingController(text: survey.description);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Survey survey = context.watch<ConstructorProvider>().survey;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Constructor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.read<ConstructorProvider>().saveSurvey();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Survey Title'),
              onChanged: context.read<ConstructorProvider>().setTitle,
            ),
            TextField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Survey short description'),
              onChanged: context.read<ConstructorProvider>().setDescription,
            ),
            Expanded(
              child: survey.questions.isEmpty
                  ? const Center(child: Text('No items added yet.'))
                  : ListView.builder(
                      itemCount: survey.questions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return survey.questions[index].toQuestionWidget();
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomSheet(),
        child: Icon(Icons.add),
      ),
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
