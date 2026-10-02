class PhoneCountry {
  const PhoneCountry({
    required this.code,
    required this.dialCode,
    required this.flag,
  });

  final String code;
  final String dialCode;
  final String flag;

  static const String fallbackCode = 'EG';

  static const List<PhoneCountry> all = <PhoneCountry>[
    PhoneCountry(code: 'EG', dialCode: '+20', flag: '🇪🇬'),
    PhoneCountry(code: 'SA', dialCode: '+966', flag: '🇸🇦'),
    PhoneCountry(code: 'AE', dialCode: '+971', flag: '🇦🇪'),
    PhoneCountry(code: 'KW', dialCode: '+965', flag: '🇰🇼'),
    PhoneCountry(code: 'QA', dialCode: '+974', flag: '🇶🇦'),
    PhoneCountry(code: 'BH', dialCode: '+973', flag: '🇧🇭'),
    PhoneCountry(code: 'OM', dialCode: '+968', flag: '🇴🇲'),
    PhoneCountry(code: 'JO', dialCode: '+962', flag: '🇯🇴'),
    PhoneCountry(code: 'LB', dialCode: '+961', flag: '🇱🇧'),
    PhoneCountry(code: 'PS', dialCode: '+970', flag: '🇵🇸'),
    PhoneCountry(code: 'IQ', dialCode: '+964', flag: '🇮🇶'),
    PhoneCountry(code: 'SY', dialCode: '+963', flag: '🇸🇾'),
    PhoneCountry(code: 'YE', dialCode: '+967', flag: '🇾🇪'),
    PhoneCountry(code: 'SD', dialCode: '+249', flag: '🇸🇩'),
    PhoneCountry(code: 'LY', dialCode: '+218', flag: '🇱🇾'),
    PhoneCountry(code: 'TN', dialCode: '+216', flag: '🇹🇳'),
    PhoneCountry(code: 'DZ', dialCode: '+213', flag: '🇩🇿'),
    PhoneCountry(code: 'MA', dialCode: '+212', flag: '🇲🇦'),
    PhoneCountry(code: 'TR', dialCode: '+90', flag: '🇹🇷'),
    PhoneCountry(code: 'GB', dialCode: '+44', flag: '🇬🇧'),
    PhoneCountry(code: 'US', dialCode: '+1', flag: '🇺🇸'),
    PhoneCountry(code: 'DE', dialCode: '+49', flag: '🇩🇪'),
    PhoneCountry(code: 'FR', dialCode: '+33', flag: '🇫🇷'),
  ];

  static PhoneCountry? find(String? code) {
    if (code == null || code.isEmpty) return null;

    final String upper = code.toUpperCase();
    for (final PhoneCountry country in all) {
      if (country.code == upper) return country;
    }
    return null;
  }

  static List<PhoneCountry> withCode(String? code, {String? dialCode}) {
    if (code == null || code.isEmpty || find(code) != null) return all;

    return <PhoneCountry>[
      PhoneCountry(
        code: code.toUpperCase(),
        dialCode: dialCode ?? '',
        flag: '🏳️',
      ),
      ...all,
    ];
  }
}
