import 'package:expense_tracker/shared/extentions.dart';
import 'package:flutter/material.dart';

class DashboardFloatingActionButton extends StatelessWidget {
  const DashboardFloatingActionButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              color: context.colors.primary,
              width: 8,
              strokeAlign: BorderSide.strokeAlignOutside)),
      child: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
