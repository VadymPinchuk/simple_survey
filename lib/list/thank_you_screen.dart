// Not allowed to use dart:html outside of web packages
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/router.dart';
import 'package:simple_survey/survey/survey_provider.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final survey = context.read<SurveyProvider>().survey;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Thank You!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Text(
                'We appreciate your time spent taking this survey.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FIXME: This button is a reason of Android app failures.
                  // Not allowed to use dart:html outside of web packages
                  ElevatedButton(
                    onPressed: () => window.close(),
                    child: const Text('Close the survey'),
                  ),
                  if (survey != null) //
                    const SizedBox(width: 16),
                  if (survey != null) //
                    ElevatedButton(
                      onPressed: () => context.goNamed(
                        Routes.stats.name,
                        pathParameters: {'sid': survey.id},
                      ),
                      child: const Text('See the stats'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
