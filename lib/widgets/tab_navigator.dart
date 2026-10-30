import 'package:flutter/material.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({super.key, required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) =>
          MaterialPageRoute(settings: settings, builder: (context) => home),
    );
  }
}
