import 'dart:math';

import 'package:base_flutter_proj/core/helpers/formatters/phone_country_data.dart';
import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  final bool useCountryCode;
  final List<PhoneCountryData>? usedCountries;
  final String? selectedMask;

  PhoneInputFormatter({
    required this.useCountryCode,
    this.usedCountries,
    this.selectedMask,
  });

  static const String maskWithOutPrefix = '000 000-00-00';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = extractDigits(newValue.text);
    final currentCountry = selectCountry(digits, usedCountries ?? []);

    final currentMask = useCountryCode
        ? (selectedMask ?? currentCountry.defaultMask)
        : maskWithOutPrefix;

    final isDeleting = newValue.text.length < oldValue.text.length;

    final maxLength = getMaxLength(currentMask);
    if (digits.length > maxLength) return oldValue;

    final formatted = _format(digits, currentCountry, currentMask, isDeleting);

    final newCursor = _calculateCursor(
      oldValue,
      newValue,
      formatted,
      isDeleting,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }

  static PhoneCountryData selectCountry(
    String digits,
    List<PhoneCountryData> countries,
  ) {
    PhoneCountryData? foundCountry;
    final countryWithSameCode = <PhoneCountryData>{};

    for (final country in countries) {
      final minLength = min(digits.length, country.code.length);

      for (var i = 0; i < minLength; i++) {
        if (digits[i] == country.code[i]) {
          if (i == country.code.length - 1) {
            foundCountry = country;
            break;
          }
          countryWithSameCode.add(country);
        } else {
          break;
        }
      }

      if (foundCountry != null) {
        break;
      }
    }

    return foundCountry ??
        (countryWithSameCode.length > 1
            ? getEmptyCountry()
            : getDefaultCountry());
  }

  static String format(
    String value, {
    bool? useCountryCode,
    List<PhoneCountryData>? usedCountries,
    String? mask,
  }) {
    return PhoneInputFormatter(
          useCountryCode: useCountryCode ?? true,
          usedCountries: usedCountries,
          selectedMask: mask,
        )
        .formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: value))
        .text;
  }

  String _format(
    String digits,
    PhoneCountryData currentCountry,
    String currentMask,
    bool isDeleting,
  ) {
    var inputDigits = digits;
    final countryCode = currentCountry.code;

    if (inputDigits.isEmpty ||
        (countryCode.isNotEmpty &&
            digits.length < countryCode.length &&
            isDeleting)) {
      return '';
    }

    //Обработка замены кода страны (например, 8 -> 7)
    if (currentCountry.codeToReplace != null &&
        digits.startsWith(currentCountry.codeToReplace!)) {
      inputDigits = digits.replaceFirst(
        currentCountry.codeToReplace!,
        currentCountry.code,
      );
    }

    if (countryCode.isNotEmpty &&
        digits.length == 1 &&
        countryCode.startsWith(digits)) {
      inputDigits = countryCode;
    }

    if (useCountryCode &&
        countryCode.isNotEmpty &&
        !inputDigits.startsWith(countryCode)) {
      inputDigits = '$countryCode$inputDigits';
    }

    final buffer = StringBuffer();
    var digitIndex = 0;

    for (
      var i = 0;
      i < currentMask.length && digitIndex < inputDigits.length;
      i++
    ) {
      buffer.write(
        currentMask[i] == '0' ? inputDigits[digitIndex++] : currentMask[i],
      );
    }

    return buffer.toString();
  }

  int _calculateCursor(
    TextEditingValue oldValue,
    TextEditingValue newValue,
    String formatted,
    bool isDeleting,
  ) {
    final cursor = newValue.selection.baseOffset;

    if (!isDeleting &&
        oldValue.text.length < newValue.text.length &&
        newValue.selection.baseOffset == newValue.text.length) {
      return formatted.length;
    }

    return cursor.clamp(0, formatted.length);
  }

  static int getMaxLength(String fullMask) {
    return fullMask.split('').where((e) => e == '0').length;
  }
}
