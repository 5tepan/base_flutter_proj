import 'package:flutter/material.dart';

class FulfillmentSegmentTab {
  const FulfillmentSegmentTab({
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
  });

  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
}
