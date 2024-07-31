import 'package:expense_tracker/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    void onSelected(index) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }

    final mDestinations = destinations
        .map((e) => NavigationDestination(icon: e.icon, label: e.label))
        .toList();

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: mDestinations,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: onSelected,
      ),
    );
  }
}
