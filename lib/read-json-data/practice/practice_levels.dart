import '../../core/design_system/app_colors.dart';
import '../models/branch.dart';
import '../models/branch_details.dart';
import '../models/inventory_item.dart';
import '../models/laboratory.dart';
import '../models/test_categories_response.dart';
import '../ui_models/inventory_item_view.dart';
import 'practice_engine.dart';
import 'previews.dart';

const String _folder = 'lib/read-json-data';

List<PracticeLevel> buildPracticeLevels() => <PracticeLevel>[
  PracticeLevel(
    number: 1,
    title: 'كائن بسيط',
    goal: 'كل قيمة في الـ JSON تتحول لحقل في الموديل بنفس نوعها.',
    files: const <String>['$_folder/models/laboratory.dart'],
    samples: <PracticeSample>[
      PracticeSample(
        path: '/laboratories/1',
        run: (dynamic body) {
          final Laboratory laboratory = Laboratory.fromJson(_asMap(body));
          return SampleParsed(
            preview: LaboratoryPreview(laboratory: laboratory),
            checks: <PracticeCheck>[
              PracticeCheck('id', expected: 1, actual: laboratory.id),
              PracticeCheck(
                'name',
                expected: 'معمل الشفاء',
                actual: laboratory.name,
              ),
              PracticeCheck(
                'phone',
                expected: '01001234567',
                actual: laboratory.phone,
              ),
              PracticeCheck(
                'isActive',
                expected: true,
                actual: laboratory.isActive,
              ),
            ],
          );
        },
      ),
    ],
  ),
  PracticeLevel(
    number: 2,
    title: 'قيم ممكن تكون فاضية',
    goal: 'نفس الموديل لازم يشتغل مع رد كامل ورد ناقص من غير ما التطبيق يقع.',
    files: const <String>['$_folder/models/branch.dart'],
    samples: <PracticeSample>[
      PracticeSample(
        path: '/branches/10',
        run: (dynamic body) {
          final Branch branch = Branch.fromJson(_asMap(body));
          return SampleParsed(
            preview: BranchPreview(branch: branch),
            checks: <PracticeCheck>[
              PracticeCheck('id', expected: 10, actual: branch.id),
              PracticeCheck(
                'name',
                expected: 'فرع مدينة نصر',
                actual: branch.name,
              ),
              PracticeCheck('isMain', expected: true, actual: branch.isMain),
              PracticeCheck(
                'address',
                expected: 'شارع عباس العقاد',
                actual: branch.address,
              ),
              PracticeCheck(
                'managerName',
                expected: 'د. سارة محمود',
                actual: branch.managerName,
              ),
            ],
          );
        },
      ),
      PracticeSample(
        path: '/branches/11',
        run: (dynamic body) {
          final Branch branch = Branch.fromJson(_asMap(body));
          return SampleParsed(
            preview: BranchPreview(branch: branch),
            checks: <PracticeCheck>[
              PracticeCheck('id', expected: 11, actual: branch.id),
              PracticeCheck(
                'name',
                expected: 'فرع المعادي',
                actual: branch.name,
              ),
              PracticeCheck('isMain', expected: false, actual: branch.isMain),
              PracticeCheck('address', expected: null, actual: branch.address),
              PracticeCheck(
                'managerName',
                expected: null,
                actual: branch.managerName,
              ),
            ],
          );
        },
      ),
    ],
  ),
  PracticeLevel(
    number: 3,
    title: 'كائن جوه كائن',
    goal:
        'لما قيمة تكون كائن كامل، حوّلها بالموديل بتاعها بدل ما تكتب الكود من الأول.',
    files: const <String>['$_folder/models/branch_details.dart'],
    requiredLevel: 1,
    samples: <PracticeSample>[
      PracticeSample(
        path: '/branches/10?include=laboratory',
        run: (dynamic body) {
          final BranchDetails branch = BranchDetails.fromJson(_asMap(body));
          return SampleParsed(
            preview: BranchDetailsPreview(branch: branch),
            checks: <PracticeCheck>[
              PracticeCheck('id', expected: 10, actual: branch.id),
              PracticeCheck(
                'name',
                expected: 'فرع مدينة نصر',
                actual: branch.name,
              ),
              PracticeCheck(
                'laboratory.id',
                expected: 1,
                actual: branch.laboratory.id,
              ),
              PracticeCheck(
                'laboratory.name',
                expected: 'معمل الشفاء',
                actual: branch.laboratory.name,
              ),
              PracticeCheck(
                'laboratory.isActive',
                expected: true,
                actual: branch.laboratory.isActive,
              ),
            ],
          );
        },
      ),
    ],
  ),
  PracticeLevel(
    number: 4,
    title: 'قايمة جوه غلاف الرد',
    goal:
        'الرد الحقيقي بييجي جوه غلاف فيه data و meta. هتطلع القايمة وتحوّل كل عنصر فيها.',
    files: const <String>[
      '$_folder/models/test_category.dart',
      '$_folder/models/test_categories_response.dart',
    ],
    samples: <PracticeSample>[
      PracticeSample(
        path: '/test-categories',
        run: (dynamic body) {
          final TestCategoriesResponse response =
              TestCategoriesResponse.fromJson(_asMap(body));
          return SampleParsed(
            preview: TestCategoriesPreview(response: response),
            checks: <PracticeCheck>[
              PracticeCheck(
                'categories.length',
                expected: 3,
                actual: response.categories.length,
              ),
              PracticeCheck(
                'categories[0].name',
                expected: 'تحاليل الدم',
                actual: response.categories.elementAtOrNull(0)?.name,
              ),
              PracticeCheck(
                'categories[1].id',
                expected: 2,
                actual: response.categories.elementAtOrNull(1)?.id,
              ),
              PracticeCheck(
                'categories[2].testsCount',
                expected: 15,
                actual: response.categories.elementAtOrNull(2)?.testsCount,
              ),
              PracticeCheck(
                'message',
                expected: 'Success',
                actual: response.message,
              ),
            ],
          );
        },
      ),
    ],
  ),
  PracticeLevel(
    number: 5,
    title: 'أنواع محتاجة تتحول',
    goal:
        'مش كل قيمة بتيجي بالنوع اللي الموديل عايزه. هتحوّل نص لرقم عشري، ونص لـ enum، ونص لتاريخ.',
    files: const <String>['$_folder/models/inventory_item.dart'],
    samples: <PracticeSample>[
      PracticeSample(
        path: '/inventory-items/501',
        run: (dynamic body) {
          final InventoryItem item = InventoryItem.fromJson(_asMap(body));
          return SampleParsed(
            preview: InventoryRawPreview(item: item),
            checks: <PracticeCheck>[
              PracticeCheck('id', expected: 501, actual: item.id),
              PracticeCheck(
                'name',
                expected: 'أنابيب سحب دم',
                actual: item.name,
              ),
              PracticeCheck('quantity', expected: 12, actual: item.quantity),
              PracticeCheck('price', expected: 150.5, actual: item.price),
              PracticeCheck(
                'status',
                expected: InventoryStatus.lowStock,
                actual: item.status,
              ),
              PracticeCheck(
                'expiresAt',
                expected: DateTime.utc(2026, 12, 31),
                actual: item.expiresAt,
              ),
            ],
          );
        },
      ),
      PracticeSample(
        path: '/inventory-items/502',
        run: (dynamic body) {
          final InventoryItem item = InventoryItem.fromJson(_asMap(body));
          return SampleParsed(
            preview: InventoryRawPreview(item: item),
            checks: <PracticeCheck>[
              PracticeCheck('id', expected: 502, actual: item.id),
              PracticeCheck('quantity', expected: 0, actual: item.quantity),
              PracticeCheck('price', expected: 90.0, actual: item.price),
              PracticeCheck(
                'status',
                expected: InventoryStatus.unknown,
                actual: item.status,
              ),
              PracticeCheck(
                'expiresAt',
                expected: DateTime.utc(2027, 3, 5),
                actual: item.expiresAt,
              ),
              PracticeCheck(
                "fromApi('in_stock')",
                expected: InventoryStatus.inStock,
                actual: _safe(() => InventoryStatus.fromApi('in_stock')),
              ),
              PracticeCheck(
                "fromApi('out_of_stock')",
                expected: InventoryStatus.outOfStock,
                actual: _safe(() => InventoryStatus.fromApi('out_of_stock')),
              ),
              PracticeCheck(
                'fromApi(null)',
                expected: InventoryStatus.unknown,
                actual: _safe(() => InventoryStatus.fromApi(null)),
              ),
            ],
          );
        },
      ),
    ],
  ),
  PracticeLevel(
    number: 6,
    title: 'من الموديل للتصميم',
    goal:
        'الموديل شكله زي البيانات، والتصميم عايز نصوص جاهزة وألوان. التحويل ده اسمه mapping.',
    files: const <String>['$_folder/ui_models/inventory_item_view.dart'],
    requiredLevel: 5,
    samples: <PracticeSample>[
      PracticeSample(
        path: '/inventory-items/501',
        run: (dynamic body) {
          final InventoryItemView view = InventoryItemView.fromModel(
            InventoryItem.fromJson(_asMap(body)),
          );
          return SampleParsed(
            preview: InventoryCardPreview(view: view),
            checks: <PracticeCheck>[
              PracticeCheck(
                'title',
                expected: 'أنابيب سحب دم',
                actual: view.title,
              ),
              PracticeCheck(
                'quantityText',
                expected: '12 قطعة',
                actual: view.quantityText,
              ),
              PracticeCheck(
                'priceText',
                expected: '150.50 ج.م',
                actual: view.priceText,
              ),
              PracticeCheck(
                'statusLabel',
                expected: 'قرب يخلص',
                actual: view.statusLabel,
              ),
              PracticeCheck(
                'statusColor',
                expected: AppColors.warning,
                actual: view.statusColor,
              ),
              PracticeCheck(
                'expiryText',
                expected: '31/12/2026',
                actual: view.expiryText,
              ),
            ],
          );
        },
      ),
      PracticeSample(
        path: '/inventory-items/502',
        run: (dynamic body) {
          final InventoryItemView view = InventoryItemView.fromModel(
            InventoryItem.fromJson(_asMap(body)),
          );
          final InventoryItemView inStock = InventoryItemView.fromModel(
            _sampleItem(InventoryStatus.inStock),
          );
          final InventoryItemView outOfStock = InventoryItemView.fromModel(
            _sampleItem(InventoryStatus.outOfStock),
          );
          return SampleParsed(
            preview: InventoryCardPreview(view: view),
            checks: <PracticeCheck>[
              PracticeCheck(
                'quantityText',
                expected: '0 قطعة',
                actual: view.quantityText,
              ),
              PracticeCheck(
                'priceText',
                expected: '90.00 ج.م',
                actual: view.priceText,
              ),
              PracticeCheck(
                'statusLabel',
                expected: 'غير معروف',
                actual: view.statusLabel,
              ),
              PracticeCheck(
                'statusColor',
                expected: AppColors.inkSubtle,
                actual: view.statusColor,
              ),
              PracticeCheck(
                'expiryText',
                expected: '05/03/2027',
                actual: view.expiryText,
              ),
              PracticeCheck(
                'inStock → statusLabel',
                expected: 'متوفر',
                actual: inStock.statusLabel,
              ),
              PracticeCheck(
                'inStock → statusColor',
                expected: AppColors.success,
                actual: inStock.statusColor,
              ),
              PracticeCheck(
                'outOfStock → statusLabel',
                expected: 'خلص',
                actual: outOfStock.statusLabel,
              ),
              PracticeCheck(
                'outOfStock → statusColor',
                expected: AppColors.danger,
                actual: outOfStock.statusColor,
              ),
            ],
          );
        },
      ),
    ],
  ),
];

Map<String, dynamic> _asMap(dynamic body) => body as Map<String, dynamic>;

InventoryItem _sampleItem(InventoryStatus status) => InventoryItem(
  id: 0,
  name: 'عينة',
  quantity: 1,
  price: 1,
  status: status,
  expiresAt: DateTime.utc(2026, 1, 1),
);

Object? _safe(Object? Function() compute) {
  try {
    return compute();
  } catch (error) {
    return 'Error: $error';
  }
}
