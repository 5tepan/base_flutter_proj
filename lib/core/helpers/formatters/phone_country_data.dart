class PhoneCountryData {
  final String name;
  final String code;
  final String countryCode;
  final List<String> masks;
  final String? codeToReplace;

  PhoneCountryData({
    required this.name,
    required this.code,
    required this.countryCode,
    required this.masks,
    this.codeToReplace,
  });

  String get defaultMask => masks.first;
}

PhoneCountryData getDefaultCountry() {
  return PhoneCountryData(
    name: 'Russia',
    code: '7',
    codeToReplace: '8',
    countryCode: 'RU',
    masks: const ['+0 (000) 000-00-00'],
  );
}

PhoneCountryData getEmptyCountry() {
  return PhoneCountryData(
    name: 'empty',
    code: '',
    countryCode: '',
    masks: const ['+00000000000'],
  );
}

String extractDigits(String value) {
  return value.replaceAll(RegExp(r'[^\d]'), '');
}
