# تمرين قراءة الـ {JSON}

## الفكرة في سطرين

- في كل مستوى، سيرفر وهمي بيرجّع {JSON}، وانت بتكتب الكود اللي بيحوّله لموديل.
- الشاشة بتعرض النتيجة في التصميم، وبتراجع كل حقل وتقولك صح ولا غلط.

---

## ليه سيرفر وهمي مش سيرفر حقيقي؟

- هدفك دلوقتي حاجة واحدة بس: **تقرا الـ {JSON} وتحوّله**.
- السيرفر الحقيقي هيزوّد حاجات تشتتك: تسجيل دخول، وتوكن، و{X-Tenant}، و{CORS}، وأخطاء نت.
- السيرفر الوهمي بيتصرف زي {Dio}: بيستنى شوية، وبعدين بيرجّع الـ {JSON} متحوّل لـ {Map}.
- يعني طريقة كتابة {`fromJson`} هنا هي نفسها اللي هتستخدمها مع السيرفر الحقيقي.
- الفرق الوحيد: الباك اند بتاعك بيحط الكائن جوه مفتاح اسمه {`data`}. فمع السيرفر الحقيقي هتبعت {`response.data['data']`} للـ {`fromJson`}، مش {`response.data`}.
- ومش محتاج تعدّل {pubspec} ولا تشغّل أي حاجة زيادة.

---

## التشغيل

شغّل الأمر ده من فولدر المشروع:

```bash
flutter run -d chrome -t lib/read-json-data/main.dart
```

- بعد أي تعديل: احفظ الملف، واضغط {r} في التيرمنال.
- لو التغيير مظهرش: اضغط {R}.

---

## القواعد

1. هتكتب في الملفات دي بس:

   ```
   lib/read-json-data/models/laboratory.dart
   lib/read-json-data/models/branch.dart
   lib/read-json-data/models/branch_details.dart
   lib/read-json-data/models/test_category.dart
   lib/read-json-data/models/test_categories_response.dart
   lib/read-json-data/models/inventory_item.dart
   lib/read-json-data/ui_models/inventory_item_view.dart
   ```

2. متغيّرش أسماء الحقول ولا الـ {constructor}، لأن الشاشة بتقرا بيهم.
3. في كل ملف هتلاقي السطر ده. امسحه واكتب الكود مكانه:

   ```dart
   throw UnimplementedError();
   ```

   ولو احتجت دالة مساعدة، مسموح تكتبها في نفس الملف تحت الكلاس.

4. فولدر {`practice`} وفولدر {`server`} مش جزء من التمرين. ده كود الشاشة والمراجعة والسيرفر الوهمي.
5. لو وقفت، افتح التلميح الأول بس، وجرّب تاني قبل ما تفتح التلميح التاني.

---

## طريقة قراية أي {JSON}

1. **بص على كل قيمة، وحدد نوعها.**
2. **قارن اسم المفتاح باسم الحقل.** السيرفر بيكتب {`is_active`}، و{Dart} بتكتب {`isActive`}.
3. **اسأل نفسك:** ممكن القيمة دي تكون {`null`}؟ ممكن متجيش خالص؟
4. **اكتب السطر.** شكله دايماً قريب من كده:

```dart
fieldName: json['key_name'] as Type,
```

### كل قيمة في الـ {JSON} نوعها إيه في {Dart}؟

- نص بين علامتين زي {`"text"`}: نوعه {`String`}.
- رقم صحيح زي {`12`}: نوعه {`int`}.
- رقم فيه علامة عشرية زي {`150.5`}: نوعه {`double`}.
- القيمة {`true`} أو {`false`}: نوعها {`bool`}.
- لو القيمة ممكن تيجي {`null`} أو متجيش خالص: اكتب نوعها العادي وبعده علامة {`?`}، زي {`String?`}.
- أقواس معقوفة {`{ }`}: نوعها {`Map<String, dynamic>`}، وغالباً بتتحول لموديل تاني.
- أقواس مربعة {`[ ]`}: نوعها {`List<dynamic>`}، وغالباً بتتحول لقايمة موديلات.

### أهم معلومة في التمرين كله

- الدالة {`jsonDecode`} ومكتبة {Dio} بيرجّعوا كل قيمة بنوع {`dynamic`}.
- عشان كده بتكتب {`as`}. معناها إنك بتقول لـ {Dart}: "أنا عارف إن القيمة دي نوعها كذا".
- لو كلامك طلع غلط، الكود بيقع برسالة شبه دي:

```
TypeError: null: type 'Null' is not a subtype of type 'String'
```

- ومعناها: القيمة اللي جت كانت {`Null`}، وانت قلت إنها {`String`}.

---

## المستوى 1: كائن بسيط

**الملف:** {`models/laboratory.dart`}

**الطلب:** {`GET /laboratories/1`}

**المطلوب:** اكتب {`Laboratory.fromJson`}.

**هتتعلم:** تقرا نوع كل قيمة، وتحوّل اسم المفتاح لاسم الحقل.

<details>
<summary>تلميح 1</summary>

الـ {JSON} فيه أربع قيم: رقم، ونصين، و{`true`}. والموديل فيه أربع حقول بنفس الأنواع دي بالظبط.

</details>

<details>
<summary>تلميح 2: مثال شبيه، مش الحل</summary>

```dart
factory Doctor.fromJson(Map<String, dynamic> json) {
  return Doctor(
    id: json['id'] as int,
    fullName: json['full_name'] as String,
  );
}
```

</details>

---

## المستوى 2: قيم ممكن تكون فاضية

**الملف:** {`models/branch.dart`}

**الطلبات:** عينتين. الأولى {`GET /branches/10`} وهي كاملة، والتانية {`GET /branches/11`} وهي ناقصة.

**المطلوب:** اكتب {`Branch.fromJson`} بحيث يشتغل مع العينتين.

**القواعد:**

- الحقلين {`address`} و{`managerName`} ممكن يبقوا {`null`}.
- الحقل {`isMain`} لو مش موجود في الـ {JSON}، قيمته تبقى {`false`}.

**هتتعلم:**

- المفتاح اللي قيمته {`null`}، والمفتاح اللي مش موجود خالص، الاتنين بيرجّعوا {`null`} لما تقراهم.
- امتى تحط علامة {`?`}، وامتى تحط قيمة بديلة بـ {`??`}.

<details>
<summary>تلميح 1</summary>

جرّب الأول تكتب {`json['address'] as String`} من غير علامة {`?`}. شوف العينة التانية هتقولك إيه، واقرا رسالة الخطأ كويس.

</details>

<details>
<summary>تلميح 2: مثال شبيه، مش الحل</summary>

```dart
nickname: json['nickname'] as String?,
isVerified: json['is_verified'] as bool? ?? false,
```

</details>

---

## المستوى 3: كائن جوه كائن

**الملف:** {`models/branch_details.dart`}

**الطلب:** {`GET /branches/10?include=laboratory`}

**لازم تخلّص المستوى 1 الأول**، لأنك هنا هتستخدم {`Laboratory.fromJson`} اللي كتبته.

**المطلوب:** اكتب {`BranchDetails.fromJson`}.

**هتتعلم:** لما قيمة تكون كائن كامل، بتحوّلها بالـ {`fromJson`} بتاع الموديل بتاعها، بدل ما تكتب نفس الكود تاني.

<details>
<summary>تلميح 1</summary>

قيمة {`json['laboratory']`} نوعها الحقيقي {`Map<String, dynamic>`}، بس {Dart} شايفاها {`dynamic`}. قولها نوعها بـ {`as`}، وابعتها لـ {`Laboratory.fromJson`}.

</details>

<details>
<summary>تلميح 2: مثال شبيه، مش الحل</summary>

```dart
doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
```

</details>

---

## المستوى 4: قايمة جوه غلاف الرد

**الملفين:** {`models/test_category.dart`} و{`models/test_categories_response.dart`}

**الطلب:** {`GET /test-categories`}

**شكل الرد:** ده نفس شكل الغلاف اللي الباك اند بتاعك بيستخدمه:

- المفتاح {`data`} جواه القايمة.
- المفتاح {`meta`} جواه معلومات عن الرد، زي {`message`}.

**المطلوب:**

1. اكتب {`TestCategory.fromJson`} لعنصر واحد من القايمة.
2. اكتب {`TestCategoriesResponse.fromJson`} للرد كله: القايمة من {`data`}، والرسالة من جوه {`meta`}.

**هتتعلم:** تحوّل {`List<dynamic>`} لـ {`List<TestCategory>`}.

<details>
<summary>تلميح 1</summary>

ابدأ بـ {`TestCategory`} لوحده، لأنه زي المستوى 1 بالظبط. بعدها في الملف التاني: خد {`json['data']`} على إنها {`List<dynamic>`}، وحوّل كل عنصر فيها. وخد {`json['meta']`} على إنها {`Map<String, dynamic>`}، واقرا منها الرسالة.

</details>

<details>
<summary>تلميح 2: مثال شبيه، مش الحل</summary>

```dart
doctors: (json['data'] as List<dynamic>)
    .map((dynamic item) => Doctor.fromJson(item as Map<String, dynamic>))
    .toList(),
```

</details>

---

## المستوى 5: أنواع محتاجة تتحول

**الملف:** {`models/inventory_item.dart`}

**الطلبات:** {`GET /inventory-items/501`} و{`GET /inventory-items/502`}

**المطلوب:** اكتب {`InventoryStatus.fromApi`} و{`InventoryItem.fromJson`}.

**العينتين دول متعمد يكونوا صعبين:**

- الحقل {`price`} جاي نص {`"150.50"`} في العينة الأولى، ورقم {`90`} في التانية. والموديل عايزه {`double`} في الحالتين.
- خلي بالك: على {Chrome} الرقم {`90`} بيعدّي من {`as double`} من غير ما يقع، لكن على الموبايل بيقع. الشاشة مش هتقدر تكشف الغلطة دي، فحوّل الرقم دايماً بـ {`toDouble()`}.
- الحقل {`status`} جاي نص، والموديل عايزه {enum} بالشكل ده:

```
in_stock             →  inStock
low_stock            →  lowStock
out_of_stock         →  outOfStock
null / anything else →  unknown
```

- الحقل {`expires_at`} جاي نص، والموديل عايزه {`DateTime`}. **متحوّلوش لتوقيت جهازك**، يعني متستخدمش {`toLocal`}.

**هتتعلم:**

- إزاي الموديل يستحمل نفس الحقل لما ييجي بنوعين مختلفين.
- إزاي تخلي التطبيق ميقعش لو السيرفر بعت قيمة جديدة مش معروفة، زي {`"discontinued"`}.

<details>
<summary>تلميح 1</summary>

الأدوات اللي هتحتاجها: {`double.parse`}، و{`num`} ومعاه {`toDouble()`}، و{`DateTime.parse`}، و{`switch`}.

عشان تعرف السعر جاي نص ولا رقم، اعمل {`switch`} على القيمة نفسها، وخلي كل حالة تتعامل مع نوع.

</details>

<details>
<summary>تلميح 2: مثال شبيه، مش الحل</summary>

تحويل نص لـ {enum}، بنفس شكل الدالة اللي في الملف:

```dart
static Priority fromApi(String? value) {
  return switch (value) {
    'high' => Priority.high,
    'low' => Priority.low,
    _ => Priority.unknown,
  };
}
```

قيمة ممكن تيجي رقم أو نص:

```dart
rating: switch (json['rating']) {
  final num value => value.toDouble(),
  final String value => double.parse(value),
  _ => 0.0,
},
```

السطر {`final num value =>`} معناه: لو القيمة رقم، سمّيها {`value`} واستخدمها.

</details>

---

## المستوى 6: من الموديل للتصميم

**الملف:** {`ui_models/inventory_item_view.dart`}

**لازم تخلّص المستوى 5 الأول.**

**الفكرة:** الموديل شكله زي البيانات، لكن التصميم عايز نصوص جاهزة وألوان. تحويل الموديل لشكل التصميم اسمه {mapping}.

**المطلوب:** اكتب {`InventoryItemView.fromModel`} بالقواعد دي:

- الحقل {`title`}: الاسم زي ما هو.
- الحقل {`quantityText`}: الكمية، وبعدها مسافة وكلمة "قطعة".
- الحقل {`priceText`}: السعر برقمين بعد العلامة العشرية، وبعده مسافة و"ج.م".
- الحقل {`expiryText`}: اليوم ثم الشهر ثم السنة، وبينهم {`/`}. واليوم والشهر دايماً خانتين.
- الحقلين {`statusLabel`} و{`statusColor`} حسب الجدول ده:

```
inStock     →  متوفر       AppColors.success
lowStock    →  قرب يخلص    AppColors.warning
outOfStock  →  خلص         AppColors.danger
unknown     →  غير معروف   AppColors.inkSubtle
```

**أمثلة للنتيجة المطلوبة:**

```
12 قطعة
150.50 ج.م
90.00 ج.م
31/12/2026
05/03/2027
```

**هتحتاج تضيف السطر ده فوق الملف** عشان تستخدم الألوان:

```dart
import '../../core/design_system/app_colors.dart';
```

<details>
<summary>تلميح 1</summary>

الأدوات اللي هتحتاجها: {`toStringAsFixed(2)`}، و{`padLeft(2, '0')`}، و{`switch`} على الـ {enum}.

</details>

<details>
<summary>تلميح 2: مثال شبيه، مش الحل</summary>

```dart
final String hour = time.hour.toString().padLeft(2, '0');

label: switch (priority) {
  Priority.high => 'عاجل',
  Priority.low => 'عادي',
  Priority.unknown => 'غير محدد',
},
```

</details>

---

## لما تخلص

- ابعتلي الملفات اللي كتبتها، وأنا أراجعها معاك سطر سطر.
- لو عايز تمسح التمرين، امسح الفولدر ده بس. مفيش أي ملف تاني في المشروع اتغيّر:

```bash
rm -rf lib/read-json-data
```

- الخطوة الجاية لو حبيت: نطبّق نفس الكلام على {endpoint} حقيقي من الباك اند بتاعك باستخدام {Dio}.
