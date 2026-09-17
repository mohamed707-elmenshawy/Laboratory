import 'package:flutter/widgets.dart';

import '../models/inventory_item.dart';

class InventoryItemView {
  final String title;
  final String quantityText;
  final String priceText;
  final String statusLabel;
  final Color statusColor;
  final String expiryText;
  const InventoryItemView({
    required this.title,
    required this.quantityText,
    required this.priceText,
    required this.statusLabel,
    required this.statusColor,
    required this.expiryText,
  });

  factory InventoryItemView.fromModel(InventoryItem item) {
    return InventoryItemView(
      title: item.name,
      quantityText: item.quantity.toString(),
      priceText: item.price.toStringAsFixed(2),
      statusLabel: item.status.name,
      statusColor: Color(item.quantity),
      expiryText: item.expiresAt.toString(),
    );
  }
}
