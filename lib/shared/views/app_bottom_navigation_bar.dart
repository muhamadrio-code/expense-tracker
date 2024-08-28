import 'package:expense_tracker/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    void onSelected(index) {
      context.go(destinations[index].route);
    }

    final mDestinations = destinations
        .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.label))
        .toList();

    return BottomNavigationBar(
      items: mDestinations,
      onTap: onSelected,
      currentIndex: currentIndex,
    );
  }
}
