import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/constructor_screen.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/list/surveys_list_screen.dart';
import 'package:simple_survey/list/thank_you_screen.dart';
import 'package:simple_survey/stats/stats_provider.dart';
import 'package:simple_survey/stats/stats_screen.dart';
import 'package:simple_survey/survey/survey_screen.dart';

enum Routes {
  surveyList('surveyList'),
  constructor('constructor'),
  survey('survey'),
  stats('stats');

  final String name;

  const Routes(this.name);
}

final GoRouter webRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      name: Routes.surveyList.name,
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ThankYouScreen();
      },
      routes: <RouteBase>[
        _surveyRoute,
        _statsRoute,
      ],
    ),
  ],
);

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      name: Routes.surveyList.name,
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SurveysListScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          name: Routes.constructor.name,
          path: '${Routes.constructor.name}/:sid',
          builder: (BuildContext context, GoRouterState state) {
            final String surveyId = state.pathParameters['sid'] as String;
            return ConstructorScreen(surveyId: surveyId);
          },
        ),
        _surveyRoute,
        _statsRoute,
      ],
    ),
  ],
);

GoRoute get _surveyRoute {
  return GoRoute(
    name: Routes.survey.name,
    path: '${Routes.survey.name}/:sid',
    builder: (BuildContext context, GoRouterState state) {
      final surveyId = state.pathParameters['sid'] as String;
      return SurveyScreen(surveyId: surveyId);
    },
  );
}

GoRoute get _statsRoute {
  return GoRoute(
    name: Routes.stats.name,
    path: '${Routes.stats.name}/:sid',
    builder: (BuildContext context, GoRouterState state) {
      final surveyId = state.pathParameters['sid'] as String;
      return ChangeNotifierProvider(
        create: (context) => StatsProvider(
          context.read<Repository>(),
        ),
        child: StatsScreen(surveyId: surveyId),
      );
    },
  );
}
