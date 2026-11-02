import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/inventory.dart';

class InventoryModel {
  const InventoryModel({
    required this.id,
    required this.medicineId,
    required this.userId,
    required this.quantity,
    required this.minStockLevel,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.expiryDate,
    required this.updatedAt,
  });

  final String id;
  final String medicineId;
  final String userId;
  final int quantity;
  final int minStockLevel;
  final double purchasePrice;
  final double sellingPrice;
  final DateTime? expiryDate;
  final DateTime? updatedAt;

  factory InventoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};
    return InventoryModel(
      id: document.id,
      medicineId: _string(data['medicineId']),
      userId: _string(data['userId']),
      quantity: _integer(data['quantity']),
      minStockLevel: _integer(data['minStockLevel']),
      purchasePrice: _number(data['purchasePrice']),
      sellingPrice: _number(data['sellingPrice']),
      expiryDate: _date(data['expiryDate']),
      updatedAt: _date(data['updatedAt']),
    );
  }

  Inventory toEntity() => Inventory(
    id: id,
    medicineId: medicineId,
    userId: userId,
    quantity: quantity,
    minStockLevel: minStockLevel,
    purchasePrice: purchasePrice,
    sellingPrice: sellingPrice,
    expiryDate: expiryDate,
    updatedAt: updatedAt,
  );

  static String _string(Object? value) => value?.toString().trim() ?? '';

  static int _integer(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _number(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _date(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
