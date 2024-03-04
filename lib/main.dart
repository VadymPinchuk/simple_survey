import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/constructor/constructor_provider.dart';
import 'package:simple_survey/constructor/question/question_edit_provider.dart';
import 'package:simple_survey/data/repository.dart';
import 'package:simple_survey/firebase_options.dart';
import 'package:simple_survey/list/surveys_list_provider.dart';
import 'package:simple_survey/router.dart';
import 'package:simple_survey/survey/survey_provider.dart';
import 'package:simple_survey/util/logger.dart';

const Color skyBlue = Color(0xFF027DFD);

final List<Color> rainbowColors = [
  Colors.red[700]!,
  Colors.orange[700]!,
  Colors.yellow[600]!,
  Colors.green[700]!,
  skyBlue,
  Colors.blue[700]!,
  Colors.purple[700]!,
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logs.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Record any exception
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(_buildApp(
    isWeb: kIsWeb,
    webAppHeight: 1600.0,
    webAppWidth: 900.0,
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
    ColorScheme lightScheme = ColorScheme.fromSeed(seedColor: Colors.deepOrange);
    ColorScheme darkScheme = ColorScheme.fromSeed(seedColor: skyBlue);
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => Repository(),
          lazy: false,
        ),
        Provider(
          create: (context) => SurveysListProvider(
            context.read<Repository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ConstructorProvider(
            context.read<Repository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => QuestionEditProvider(
            context.read<ConstructorProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SurveyProvider(
            context.read<Repository>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,//kIsWeb ? webRouter : router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        themeMode: ThemeMode.light,
        theme: ThemeData.light().copyWith(
          colorScheme: lightScheme,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: darkScheme,
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => AppLocalizations.of(context)!.application_title,
      ),
    );
  }
}
