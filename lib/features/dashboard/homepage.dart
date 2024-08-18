import 'package:expense_tracker/shared/extensions.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool mode = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          mode = !mode;
          context.setThemeMode(mode ? ThemeMode.dark : ThemeMode.light);
        },
        child: const Text("Homepage"),
      ),
    );
  }
}
