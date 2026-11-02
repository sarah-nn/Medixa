import 'package:equatable/equatable.dart';

class Inventory extends Equatable {
  const Inventory({
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

  @override
  List<Object?> get props => [
    id,
    medicineId,
    userId,
    quantity,
    minStockLevel,
    purchasePrice,
    sellingPrice,
    expiryDate,
    updatedAt,
  ];
}
