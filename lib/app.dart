import 'package:flutter/material.dart';

import 'screens/theme_preview_screen.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Axis',
      theme: AppTheme.light,
      home: const ThemePreviewScreen(),
    );
  }
}
