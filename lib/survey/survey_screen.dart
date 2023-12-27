import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/models/student.dart';
import 'package:simple_survey/router.dart';
import 'package:simple_survey/survey/survey_provider.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  @override
  void didChangeDependencies() {
    context.read<SurveyProvider>().requestStudents();
    super.didChangeDependencies();
  }

  Widget votingSection(
    String title,
    double score,
    ValueChanged<double> onChanged,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            const Spacer(),
            Text(
              score.round().toString(),
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Slider(
            value: score,
            min: 0,
            max: 30,
            divisions: 30,
            label: score.round().toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.vote_screen_title),
        actions: [
          if (!kIsWeb)
            IconButton(
              onPressed: () => context.goNamed(Routes.stats.name),
              icon: const Icon(Icons.bar_chart),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                strings.vote_select_presenter,
                style: theme.textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Selector<SurveyProvider, List<Student>>(
                        selector: (_, provider) => provider.students,
                        builder: (context, list, __) {
                          if (list.isNotEmpty) {
                            return DropdownMenu<Student>(
                              onSelected: (Student? value) {
                                context
                                    .read<SurveyProvider>()
                                    .selectStudent(value!);
                              },
                              dropdownMenuEntries: list
                                  .map<DropdownMenuEntry<Student>>(
                                      (Student value) =>
                                          DropdownMenuEntry<Student>(
                                            value: value,
                                            label: value.name,
                                          ))
                                  .toList(),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                    Selector<SurveyProvider, double>(
                      selector: (_, provider) => provider.voteAverage,
                      builder: (context, score, __) {
                        return Center(
                          child: Text(
                            score.round().toString(),
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: theme.colorScheme.primaryContainer,
                              fontSize: 36,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Selector<SurveyProvider, double>(
                selector: (_, provider) => provider.voteIdea,
                builder: (context, score, __) {
                  return votingSection(
                    strings.vote_for_idea,
                    score,
                    (score) {
                      context.read<SurveyProvider>().changeScore(idea: score);
                    },
                  );
                },
              ),
              Selector<SurveyProvider, double>(
                selector: (_, provider) => provider.votePresentation,
                builder: (context, score, __) {
                  return votingSection(
                    strings.vote_for_presentation,
                    score,
                    (score) {
                      context
                          .read<SurveyProvider>()
                          .changeScore(presentation: score);
                    },
                  );
                },
              ),
              Selector<SurveyProvider, double>(
                selector: (_, provider) => provider.voteImplementation,
                builder: (context, score, __) {
                  return votingSection(
                    strings.vote_for_implementation,
                    score,
                    (score) {
                      context
                          .read<SurveyProvider>()
                          .changeScore(implementation: score);
                    },
                  );
                },
              ),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Selector<SurveyProvider, bool>(
                  selector: (_, provider) => provider.isReadyToVote,
                  builder: (context, isReady, __) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        disabledBackgroundColor:
                            theme.colorScheme.secondaryContainer,
                        disabledForegroundColor:
                            theme.colorScheme.onSecondaryContainer,
                        minimumSize: const Size(88, 48),
                        padding: const EdgeInsets.all(16.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      onPressed: isReady
                          ? context.read<SurveyProvider>().sendVote
                          : null,
                      child: Text(strings.vote_send),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
