import 'package:base_flutter_proj/core/helpers/formatters/phone_country_data.dart';
import 'package:base_flutter_proj/core/helpers/formatters/phone_input_formatter.dart';

class PhoneInputHelper {
  static final List<PhoneCountryData> _usedCountryInProject = [
    PhoneCountryData(
      name: 'Russia',
      code: '7',
      codeToReplace: '8',
      countryCode: 'RU',
      masks: ['+0 (000) 000-00-00', '+ 0 000 000 00 00'],
    ),
  ];

  static final defaultPhoneInputFormatter = [
    PhoneInputFormatter(
      useCountryCode: true,
      usedCountries: _usedCountryInProject,
    ),
  ];

  static String getFormattedPhone(
    String value, {
    bool? useCountryCode,
    String? countryCode,
    int? maskIndex,
    String? mask,
  }) {
    final resolvedMask = _resolveMask(
      value,
      countryCode: countryCode,
      maskIndex: maskIndex,
      mask: mask,
    );

    return PhoneInputFormatter.format(
      value,
      useCountryCode: useCountryCode ?? true,
      usedCountries: _usedCountryInProject,
      mask: resolvedMask,
    );
  }

  static bool isPhoneValid(String phone) {
    if (phone.isEmpty) return false;

    final digits = extractDigits(phone);

    for (final country in _usedCountryInProject) {
      if (!digits.startsWith(country.code)) continue;

      for (final mask in country.masks) {
        if (extractDigits(mask).length == digits.length) {
          return true;
        }
      }
    }

    return false;
  }

  static String? _resolveMask(
    String value, {
    String? countryCode,
    int? maskIndex,
    String? mask,
  }) {
    if (mask != null) {
      return mask;
    }

    PhoneCountryData? country;

    if (countryCode != null) {
      for (final item in _usedCountryInProject) {
        if (item.countryCode == countryCode) {
          country = item;
          break;
        }
      }
    } else {
      final digits = extractDigits(value);
      for (final item in _usedCountryInProject) {
        if (digits.startsWith(item.code)) {
          country = item;
          break;
        }
      }
    }

    if (country == null) return null;

    if (maskIndex != null &&
        maskIndex >= 0 &&
        maskIndex < country.masks.length) {
      return country.masks[maskIndex];
    }

    return country.defaultMask;
  }
}
