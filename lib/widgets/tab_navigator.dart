import 'package:flutter/material.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.home,
  });

  // 外（RootScreen）から、このタブの画面の積み重ねを操作するための鍵
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) =>
          MaterialPageRoute(settings: settings, builder: (context) => home),
    );
  }
}
