enum InventoryStatus {
  inStock,
  lowStock,
  outOfStock,
  unknown;

  static InventoryStatus fromApi(String? value) {
    switch (value) {
      case 'in_stock':
        return InventoryStatus.inStock;
      case 'low_stock':
        return InventoryStatus.lowStock;
      case 'out_of_stock':
        return InventoryStatus.outOfStock;
      default:
        return InventoryStatus.unknown;
    }
  }
}

class InventoryItem {
  final int id;
  final String name;
  final int quantity;
  final double price;
  final InventoryStatus status;
  final DateTime expiresAt;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.status,
    required this.expiresAt,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      quantity: (json['quantity']),
      price: double.parse(json['price'].toString()),
      status: InventoryStatus.fromApi(json['status']),
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }
}
