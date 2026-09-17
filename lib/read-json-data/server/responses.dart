abstract final class FakeResponses {
  static const String laboratory = r'''
{
  "id": 1,
  "name": "معمل الشفاء",
  "phone": "01001234567",
  "is_active": true
}''';

  static const String branchComplete = r'''
{
  "id": 10,
  "name": "فرع مدينة نصر",
  "address": "شارع عباس العقاد",
  "manager_name": "د. سارة محمود",
  "is_main": true
}''';

  static const String branchIncomplete = r'''
{
  "id": 11,
  "name": "فرع المعادي",
  "address": null
}''';

  static const String branchWithLaboratory = r'''
{
  "id": 10,
  "name": "فرع مدينة نصر",
  "laboratory": {
    "id": 1,
    "name": "معمل الشفاء",
    "phone": "01001234567",
    "is_active": true
  }
}''';

  static const String testCategories = r'''
{
  "data": [
    { "id": 1, "name": "تحاليل الدم", "tests_count": 24 },
    { "id": 2, "name": "وظائف الكبد", "tests_count": 8 },
    { "id": 3, "name": "الهرمونات", "tests_count": 15 }
  ],
  "meta": {
    "message": "Success",
    "code": 200,
    "error": false,
    "validation_errors": []
  }
}''';

  static const String inventoryLowStock = r'''
{
  "id": 501,
  "name": "أنابيب سحب دم",
  "quantity": 12,
  "price": "150.50",
  "status": "low_stock",
  "expires_at": "2026-12-31T00:00:00.000000Z"
}''';

  static const String inventoryUnknownStatus = r'''
{
  "id": 502,
  "name": "شرائح زجاجية",
  "quantity": 0,
  "price": 90,
  "status": "discontinued",
  "expires_at": "2027-03-05T00:00:00.000000Z"
}''';

  static const Map<String, String> byPath = <String, String>{
    '/laboratories/1': laboratory,
    '/branches/10': branchComplete,
    '/branches/11': branchIncomplete,
    '/branches/10?include=laboratory': branchWithLaboratory,
    '/test-categories': testCategories,
    '/inventory-items/501': inventoryLowStock,
    '/inventory-items/502': inventoryUnknownStatus,
  };
}
