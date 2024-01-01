import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/models/questions/question_to_widget_transformer.dart';
import 'package:simple_survey/router.dart';
import 'package:simple_survey/survey/survey_provider.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';

class SurveyScreen extends StatelessWidget {
  const SurveyScreen({
    super.key,
    required this.surveyId,
  });

  final String surveyId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppLocalizations.of(context)!;
    final survey = context.watch<SurveyProvider>().survey;
    if (survey == null) {
      return const Center(
        child: SizedBox.square(
          dimension: 150,
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(survey.title),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              await context.read<SurveyProvider>().sendResponse().then(
                    (value) => context.pop(),
                  );
            },
          ),
          if (!kIsWeb)
            IconButton(
              onPressed: () => context.goNamed(Routes.stats.name),
              icon: const Icon(Icons.bar_chart),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                survey.description,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: survey.questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return survey.questions[index].toQuestionWidget(
                    mode: QuestionMode.submit,
                    onChanged: context.read<SurveyProvider>().updateProgress,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
