import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/tab_navigator.dart';
import 'axis/axis_screen.dart';
import 'home/home_screen.dart';
import 'journey/journey_screen.dart';
import 'settings/settings_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late int _currentIndex = widget.initialIndex;
  static const _axisTabIndex = 1;
  // タブごとの画面の積み重ねの鍵（ホーム・自分の軸・あゆみ・設定）
  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  void _onTabTap(int index) {
    // 開いているタブをもう一度押したら、そのタブの最初の画面に戻る
    if (index == _currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      TabNavigator(
        navigatorKey: _navigatorKeys[0],
        home: HomeScreen(
          onOpenAxis: () => setState(() => _currentIndex = _axisTabIndex),
        ),
      ),
      TabNavigator(navigatorKey: _navigatorKeys[1], home: const AxisScreen()),
      TabNavigator(
        navigatorKey: _navigatorKeys[2],
        home: const JourneyScreen(),
      ),
      TabNavigator(
        navigatorKey: _navigatorKeys[3],
        home: const SettingsScreen(),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
      ),
    );
  }
}
