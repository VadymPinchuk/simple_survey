import 'package:blur/blur.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/models/questions/question_to_widget_transformer.dart';
import 'package:simple_survey/models/questions/survey_question.dart';
import 'package:simple_survey/router.dart';
import 'package:simple_survey/survey/survey_provider.dart';
import 'package:simple_survey/widgets/loader.dart';
import 'package:simple_survey/widgets/questions/base_question_widget.dart';

const String _url =
    'https://static.wixstatic.com/media/6e1ab2_82fe1012f6fb45b3b1a7fcf042969adc~mv2.png/v1/fill/w_660,h_574,al_c,q_90,usm_0.66_1.00_0.01,enc_auto/dcam23-landmark.png';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({
    super.key,
    required this.surveyId,
  });

  final String surveyId;

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  @override
  void didChangeDependencies() {
    context.read<SurveyProvider>().selectSurvey(widget.surveyId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppLocalizations.of(context)!;
    final survey = context.watch<SurveyProvider>().survey;
    if (survey == null) return const Loader();
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
      body: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Blur(
              blur: 5,
              blurColor: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: Image.network(_url),
                ),
              ),
            ),
          ),
          Padding(
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
                      return Selector<SurveyProvider, SurveyQuestion>(
                        selector: (_, provider) {
                          return provider.questionsList[index];
                        },
                        builder: (_, SurveyQuestion question, __) {
                          return question.toQuestionWidget(
                            mode: QuestionMode.submit,
                            onChanged: context.read<SurveyProvider>().updateProgress,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
