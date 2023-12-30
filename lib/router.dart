import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_survey/constructor/constructor_screen.dart';
import 'package:simple_survey/list/surveys_list_screen.dart';
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
            final surveyId = state.pathParameters['sid'] as String;
            return const ConstructorScreen();
          },
        ),
        GoRoute(
          name: Routes.stats.name,
          path: '${Routes.stats.name}/:sid',
          builder: (BuildContext context, GoRouterState state) {
            return const StatsScreen();
          },
        ),
      ],
    ),
  ],
);

final GoRouter routerWeb = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      name: Routes.surveyList.name,
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SurveysListScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          name: Routes.survey.name,
          path: '${Routes.survey.name}/:sid',
          builder: (BuildContext context, GoRouterState state) {
            // final surveyId = 'WUrCUd5vMRsXmCftBAGy';
            final surveyId = state.pathParameters['sid'] as String;
            return SurveyScreen(surveyId: surveyId);
          },
        ),
      ],
    ),
  ],
);
