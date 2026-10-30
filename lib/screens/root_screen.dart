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

  @override
  Widget build(BuildContext context) {
    final screens = [
      TabNavigator(
        home: HomeScreen(
          onOpenAxis: () => setState(() => _currentIndex = _axisTabIndex),
        ),
      ),
      const TabNavigator(home: AxisScreen()),
      const TabNavigator(home: JourneyScreen()),
      const TabNavigator(home: SettingsScreen()),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
      ),
    );
  }
}
