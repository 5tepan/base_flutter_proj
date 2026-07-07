/// Ссылки на статические информационные страницы.
class InfoPageHolder {
  const InfoPageHolder({
    this.privacyPolicy,
    this.termsOfUse,
  });

  final String? privacyPolicy;
  final String? termsOfUse;

  factory InfoPageHolder.fromJson(Map<String, dynamic> json) {
    return InfoPageHolder(
      privacyPolicy: json['privacy-policy'] as String?,
      termsOfUse: json['terms-of-use'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (privacyPolicy != null) 'privacy-policy': privacyPolicy,
        if (termsOfUse != null) 'terms-of-use': termsOfUse,
      };
}
