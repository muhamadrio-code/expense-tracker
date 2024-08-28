import 'package:expense_tracker/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  final String _title;
  final TextStyle? _titleTextStyle;
  final TextStyle? _expenseTextStyle;
  final EdgeInsetsGeometry? _padding;
  final EdgeInsetsGeometry? _margin;
  final Alignment? _alignment;

  const ExpenseCard({
    String? title,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Alignment? alignment,
    NumberFormat? formatter,
    TextStyle? titleTextStyle,
    TextStyle? expenseTextStyle,
    super.key,
  })  : _title = title ?? "Total expense this month",
        _padding = padding ?? const EdgeInsets.all(8.0),
        _margin = margin ?? const EdgeInsets.all(16),
        _alignment = alignment ?? Alignment.center,
        _titleTextStyle = titleTextStyle,
        _expenseTextStyle = expenseTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: _alignment,
      padding: _padding,
      margin: _margin,
      child: Column(
        children: [
          Text(
            _title,
            style: _titleTextStyle ??
                context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface.withOpacity(.5),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            //TODO: stream formatted Expense value from local database/Bloc.
            "Rp1.000.000,00",
            style: _expenseTextStyle ??
                context.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
