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
  })  : _padding = padding ?? const EdgeInsets.all(16.0),
        _titleText = "Upcoming",
        _actionText = "See all >";

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: _padding,
        sliver: SliverStickyHeader(
          header: _SliverStickyExpenseListHeader(
            title: Text(
              _titleText,
              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface.withOpacity(.5),
              ),
            ),
            actions: [
              Text(
                _actionText,
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface.withOpacity(.8),
                ),
              ),
            ],
          ),
          sliver: SliverList.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 16,
            ),
            itemBuilder: (context, i) => ListTile(
              title: Text("Title Tile $i"),
              subtitle: Text("Subtitile $i"),
              leading: const Icon(
                Icons.alarm,
              ),
            ),
            itemCount: 50,
          ),
        ));
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
