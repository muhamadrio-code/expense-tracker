import 'package:expense_tracker/router/router.dart';
import 'package:expense_tracker/shared/views/bottom_navigation_bar.dart';
import 'package:expense_tracker/shared/views/floating_action_butoon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootLayout extends StatelessWidget {
  const RootLayout(
      {required this.child, required this.currentIndex, super.key});

  final Widget child;
  final int currentIndex;
  static const _bttomAppBarKey = ValueKey('bottomNavigationKey');

  @override
  Widget build(BuildContext context) {
    void onSelected(index) {
      final destination = destinations[index];
      GoRouter.of(context).go(destination.route);
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: AppNavigationBar(
          key: _bttomAppBarKey,
          destinations: destinations,
          selectedIndex: currentIndex,
          onDestinationSelected: onSelected),
      floatingActionButton: DashboardFloatingActionButton(
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
