import 'package:expense_tracker/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootLayout extends StatelessWidget {
  const RootLayout(
      {required this.child, required this.currentIndex, super.key});

  final Widget child;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    void onSelected(index) {
      final Destination destination = destinations[index];
      GoRouter.of(context).go(destination.route);
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: destinations
              .map((e) => NavigationDestination(icon: e.icon, label: e.label))
              .toList(),
          selectedIndex: currentIndex,
          onDestinationSelected: onSelected),
    );
  }
}
