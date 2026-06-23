import 'package:flutter/material.dart';

class BottomPickerHeader extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color closeIconColor;
  final TextStyle? titleStyle;
  final VoidCallback? onClosePressed;

  const BottomPickerHeader({
    required this.title,
    required this.backgroundColor,
    required this.closeIconColor,
    super.key,
    this.padding = const EdgeInsets.only(top: 5, bottom: 15),
    this.titleStyle,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          Text(title, style: titleStyle, textAlign: TextAlign.center),
          IconButton(
            icon: Icon(Icons.close, color: closeIconColor),
            onPressed: onClosePressed ?? () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
