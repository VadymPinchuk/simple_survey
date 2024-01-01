import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
                      IconButton(
                        onPressed: () => context.goNamed(
                          Routes.stats.name,
                          pathParameters: {'sid': survey.id},
                        ),
                        icon: const Icon(Icons.bar_chart),
                      ),
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
