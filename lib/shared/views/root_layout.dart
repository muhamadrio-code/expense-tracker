import 'package:expense_tracker/shared/views/app_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({
    required this.body,
    required this.floatingActionButton,
    required this.pageIndex,
    super.key,
  });

  final Widget body;
  final Widget floatingActionButton;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: AppBottomNavigationBar(currentIndex: pageIndex),
      ),
    );
  }
}
