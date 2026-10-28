import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'repositories/action_repository.dart';
import 'repositories/vision_repository.dart';
import 'screens/root_screen.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.visionRepository,
    required this.actionRepository,
  });

  final VisionRepository visionRepository;
  final ActionRepository actionRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Axis',
      theme: AppTheme.light,
      locale: const Locale('ja'),
      supportedLocales: const [Locale('ja')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: RootScreen(
        visionRepository: visionRepository,
        actionRepository: actionRepository,
      ),
    );
  }
}
