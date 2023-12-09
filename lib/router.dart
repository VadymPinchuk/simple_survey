import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_survey/vote/vote_screen.dart';
import 'package:simple_survey/vote_web_screen.dart';

import 'chart/chart_screen.dart';

enum Routes {
  vote('vote'),
  chart('chart');

  final String name;

  const Routes(this.name);
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      name: Routes.vote.name,
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const VoteScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          name: Routes.chart.name,
          path: Routes.chart.name,
          builder: (BuildContext context, GoRouterState state) {
            return const ChartScreen();
          },
        ),
      ],
    ),
  ],
);

final GoRouter routerWeb = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const VoteWebScreen();
      },
    ),
  ],
);
