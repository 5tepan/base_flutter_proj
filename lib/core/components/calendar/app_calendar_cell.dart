import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

class AppCalendarCellStyle {
  const AppCalendarCellStyle({
    required this.size,
    required this.color,
    this.badgeColor,
    this.textColor,
  });

  final double size;
  final Color color;
  final Color? badgeColor;
  final Color? textColor;
}

class AppCalendarCell extends StatelessWidget {
  const AppCalendarCell({
    super.key,
    required this.text,
    required this.style,
  });

  final String text;
  final AppCalendarCellStyle style;

  @override
  Widget build(BuildContext context) {
    var cellWidget = _buildCell();
    if (style.badgeColor != null) {
      cellWidget = Stack(
        children: [
          cellWidget,
          Positioned(
            top: 4,
            right: 4,
            child: _Badge(color: style.badgeColor!),
          ),
        ],
      );
    }
    return cellWidget;
  }

  Widget _buildCell() {
    return Container(
      height: style.size,
      width: style.size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: style.color,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: AppTextStyle.body.copyWith(color: style.textColor),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
