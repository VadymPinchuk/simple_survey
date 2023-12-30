import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/models/questions/question_to_widget_transformer.dart';
import 'package:simple_survey/router.dart';
import 'package:simple_survey/survey/survey_provider.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({
    super.key,
    required this.surveyId,
  });

  final String surveyId;

  @override
  State<StatefulWidget> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  @override
  void didChangeDependencies() {
    context.read<SurveyProvider>().fetchSurvey(widget.surveyId);
    super.didChangeDependencies();
  }

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
    // return FutureBuilder<Survey?>(
    //   future: context.read<SurveyProvider>().fetchSurvey(widget.surveyId),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       return const Center(
    //         child: SizedBox.square(
    //           dimension: 150,
    //           child: CircularProgressIndicator(),
    //         ),
    //       );
    //     }
    //     if (snapshot.data == null ||
    //         snapshot.connectionState != ConnectionState.done) {
    //       return const Center(
    //         child: Text('No survey available'),
    //       );
    //     }
    //     final Survey survey = snapshot.requireData!;
    return Scaffold(
      appBar: AppBar(
        title: Text(survey.title),
        automaticallyImplyLeading: false,
        actions: [
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
                    onChanged:
                        context.read<SurveyProvider>().updateProgress,
                  );
                },
              ),
            )
          ],
        ),
      ),
      // );
      // },
    );
  }
}
