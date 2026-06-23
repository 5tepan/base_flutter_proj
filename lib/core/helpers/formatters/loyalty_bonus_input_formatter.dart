import 'package:flutter/services.dart';

class LoyaltyBonusInputFormatter extends TextInputFormatter {
  LoyaltyBonusInputFormatter({required this.maxValue, this.minValue = 1})
    : assert(minValue >= 0);

  final int minValue;
  final int maxValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (maxValue < minValue) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final parsed = int.tryParse(digits);
    if (parsed == null) return oldValue;

    final clamped = parsed.clamp(minValue, maxValue);
    final text = clamped.toString();

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
