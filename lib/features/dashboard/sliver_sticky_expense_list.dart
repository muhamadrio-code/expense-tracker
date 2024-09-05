import 'package:expense_tracker/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class SliverStickyExpenseList extends StatelessWidget {
  final EdgeInsetsGeometry _padding;
  final String _titleText;
  final String _actionText;

  const SliverStickyExpenseList({
    EdgeInsetsGeometry? padding,
    super.key,
  })  : _padding = padding ?? const EdgeInsets.all(0.0),
        _titleText = "30 Agu Jumat",
        _actionText = "Pengeluaran 500,000";

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 12,
      color: context.colors.onSurface.withOpacity(.87),
    );

    Color backgroundColor = context.colors.surfaceContainerLow;

    return SliverMainAxisGroup(slivers: [
      SliverAppBar(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Expanded(
                child: Text(
              _titleText,
              style: textStyle,
            )),
            Text(_actionText, style: textStyle),
          ],
        ),
      ),
      SliverList.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 4,
        ),
        itemBuilder: (context, i) => ListTile(
          title: Text("Title Tile $i"),
          leading: const Icon(
            Icons.alarm,
          ),
          trailing: const Text("50,000.00"),
        ),
        itemCount: 5,
      ),
    ]);
  }
}

class _SliverStickyExpenseListHeader extends StatelessWidget {
  final Widget _title;
  final List<Widget> _actions;

  const _SliverStickyExpenseListHeader({
    required Widget title,
    required List<Widget> actions,
  })  : _actions = actions,
        _title = title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(color: context.colors.surface),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _title,
          ..._actions,
        ],
      ),
    );
  }
}
