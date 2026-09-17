// اكتب الموديلات بتاعتك جوه فولدر models/، وبعدين اربط كل ملف JSON بالموديل بتاعه هنا.
//
// مثال بعد ما تعمل models/user.dart:
//   import 'models/user.dart';
//   '1_user.json': (dynamic json) => User.fromJson(json as Map<String, dynamic>),
//
// الشاشة هتعرض نتيجة كل سطر. اعمل toString() في الموديل عشان تشوف القيم.

import 'models/user.dart';

typedef Parser = Object? Function(dynamic json);

final Map<String, Parser> parsers = <String, Parser>{
  '1_user.json': (dynamic json) =>
      UserModel.fromJson(json as Map<String, dynamic>),
  '2_product.json': (dynamic json) => null,
  '3_profile.json': (dynamic json) => null,
  '4_posts.json': (dynamic json) => null,
  '5_categories_response.json': (dynamic json) => null,
  '6_appointment.json': (dynamic json) => null,
  '7_lab_sections.json': (dynamic json) => null,
  '8_exchange_rates.json': (dynamic json) => null,
};
