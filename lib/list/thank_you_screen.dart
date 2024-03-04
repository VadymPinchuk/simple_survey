// Not allowed to use dart:html outside of web packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/survey/survey_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const String _url = 'https://linktr.ee/vpinchuk';

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
                'I appreciate your time spent taking this survey',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              const Text(
                'If you would love follow the speaker journey'
                    '\nPlease follow the link below',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse(_url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text('LinkTree'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
