import 'package:expense_tracker/shared/views/bottom_sheet_header.dart';
import 'package:flutter/material.dart';

class SliverBottomSheetHeaderDelegate extends SliverPersistentHeaderDelegate {
  const SliverBottomSheetHeaderDelegate({
    required this.title,
    this.centerTItle = false,
    this.titleStyle,
    this.trailingIcon,
    this.leadingIcon,
    this.backgroundColor,
    this.iconStyle,
  });

  final String title;
  final TextStyle? titleStyle;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final Color? backgroundColor;
  final ButtonStyle? iconStyle;
  final bool centerTItle;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BottomSheetHeader(
      title: title,
      titleStyle: titleStyle,
      trailingIcon: trailingIcon,
      leadingIcon: leadingIcon,
      backgroundColor: backgroundColor,
      iconStyle: iconStyle,
      centerTItle: centerTItle,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  double get maxExtent => kToolbarHeight + 16;

  @override
  double get minExtent => kToolbarHeight + 16;
}
