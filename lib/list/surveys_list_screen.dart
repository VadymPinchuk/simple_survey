import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/list/surveys_list_provider.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/router.dart';
import 'package:simple_survey/widgets/loader.dart';

class SurveysListScreen extends StatelessWidget {
  const SurveysListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of created surveys'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<Survey>>(
          stream: context.read<SurveysListProvider>().streamOfSurveys(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loader();
            }
            return ListView.builder(
              itemCount: snapshot.requireData.length,
              itemBuilder: (context, index) {
                final Survey survey = snapshot.requireData[index];
                return ListTile(
                  title: Text(
                    survey.titleToPascalCase(),
                    style: theme.textTheme.titleMedium!,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (kIsWeb)
                        IconButton(
                          onPressed: () => context.goNamed(
                            Routes.survey.name,
                            pathParameters: {'sid': survey.id},
                          ),
                          icon: const Icon(Icons.arrow_forward_ios_outlined),
                        ),
                      if (!kIsWeb)
                        IconButton(
                          onPressed: () {
                            context.read<SurveysListProvider>().copySurvey(survey).then(
                              (copy) {
                                context.goNamed(
                                  Routes.constructor.name,
                                  pathParameters: {'sid': copy.id},
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      IconButton(
                        onPressed: () => context.goNamed(
                          Routes.stats.name,
                          pathParameters: {'sid': survey.id},
                        ),
                        icon: const Icon(Icons.bar_chart),
                      ),
                      if (!kIsWeb)
                        IconButton(
                          onPressed: () => context.goNamed(
                            Routes.constructor.name,
                            pathParameters: {'sid': survey.id},
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                    ],
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(
            Routes.constructor.name,
            pathParameters: {'sid': '  '},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
