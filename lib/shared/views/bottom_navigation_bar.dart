import 'package:expense_tracker/router/router.dart';
import 'package:flutter/material.dart';

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar(
      {super.key, required this.destinations, required this.selectedIndex});

  final List<Widget> destinations;
  final int selectedIndex;

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(destinations.length, (index) {
            return destinations[index].child ?? const Icon(Icons.error_outline);
          })),
    );
  }
}
