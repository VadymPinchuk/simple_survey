import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/chart/chart_provider.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/firebase_options.dart';
import 'package:simple_survey/router.dart';
import 'package:simple_survey/util/logger.dart';
import 'package:simple_survey/vote/voting_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logs.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(_buildApp(
    isWeb: kIsWeb,
    webAppWidth: 1280.0,
    webAppHeight: 800.0,
    app: const VoteApp(),
  ));
}

Widget _buildApp({
  required bool isWeb,
  required double webAppWidth,
  required double webAppHeight,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }
  return Center(
    child: ClipRect(
      child: SizedBox(
        width: webAppWidth,
        height: webAppHeight,
        child: app,
      ),
    ),
  );
}

class VoteApp extends StatelessWidget {
  const VoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme lightScheme =
        ColorScheme.fromSeed(seedColor: Colors.red);
    ColorScheme darkScheme = ColorScheme.fromSeed(seedColor: Colors.purple);
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => Repository(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => VotingProvider(
            context.read<Repository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ChartProvider(
            context.read<Repository>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: kIsWeb ? routerWeb : router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.light().copyWith(
          colorScheme: lightScheme,
          brightness: Brightness.light,
          appBarTheme: ThemeData.light().appBarTheme.copyWith(
                backgroundColor: lightScheme.secondaryContainer,
                foregroundColor: lightScheme.onSecondaryContainer,
              ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: darkScheme,
          brightness: Brightness.dark,
          appBarTheme: ThemeData.dark().appBarTheme.copyWith(
                backgroundColor: darkScheme.secondaryContainer,
                foregroundColor: darkScheme.onSecondaryContainer,
              ),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) =>
            AppLocalizations.of(context)!.application_title,
      ),
    );
  }
}
