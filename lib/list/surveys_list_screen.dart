import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/constructor_provider.dart';
import 'package:simple_survey/list/surveys_list_provider.dart';
import 'package:simple_survey/models/survey.dart';
import 'package:simple_survey/router.dart';

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
      body: FutureBuilder<List<Survey>>(
          future: context.read<SurveysListProvider>().getSurveysList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: SizedBox.square(
                  dimension: 150,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.requireData.isEmpty ||
                snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: Text('No items available'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.requireData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    snapshot.requireData[index].titleToPascalCase(),
                    style: theme.textTheme.titleMedium!,
                  ),
                  onTap: () async {
                    final String surveyId = snapshot.requireData[index].id;
                    if (kIsWeb) {
                      context.goNamed(
                        Routes.survey.name,
                        pathParameters: {'sid': surveyId},
                      );
                    } else {
                      await context
                          .read<ConstructorProvider>()
                          .selectSurvey(surveyId)
                          .then(
                            (value) => context.goNamed(
                              Routes.constructor.name,
                              pathParameters: {'sid': surveyId},
                            ),
                          );
                    }
                  },
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ConstructorProvider>().selectSurvey('');
          context.goNamed(
            Routes.constructor.name,
            pathParameters: {'sid': 'newSurvey'},
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
