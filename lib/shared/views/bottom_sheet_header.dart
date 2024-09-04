import 'package:expense_tracker/shared/extensions.dart';
import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  final Color? backgroundColor;
  final ButtonStyle? iconStyle;
  final bool centerTItle;

  const BottomSheetHeader(
      {super.key,
      required this.title,
      this.centerTItle = false,
      this.titleStyle,
      this.trailingIcon,
      this.leadingIcon,
      this.backgroundColor,
      this.iconStyle});

  @override
  Widget build(BuildContext context) {
    void closeSheet() => Navigator.pop(context);

    final TextStyle titleStyle = this.titleStyle ??
        TextStyle(
          fontWeight: FontWeight.bold,
          color: context.colors.onSurface,
          fontSize: 20,
        );

    final Widget title = Text(
      textAlign: centerTItle ? TextAlign.center : TextAlign.start,
      this.title,
      style: titleStyle,
    );

    final Widget leadingIcon =
        this.leadingIcon ?? const Icon(Icons.close_rounded);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.surfaceContainerHighest,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              child: IconButton(
            style: iconStyle,
            onPressed: closeSheet,
            icon: leadingIcon,
          )),
          const SizedBox(
            width: 8,
          ),
          Expanded(child: title),
          const SizedBox(
            width: 8,
          ),
          if (trailingIcon != null) Flexible(child: trailingIcon!),
        ],
      ),
    );
  }
}
