import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/inventory.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../models/inventory_model.dart';
import '../models/medicine_model.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  MedicineRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _medicines =>
      _firestore.collection('medicines');

  CollectionReference<Map<String, dynamic>> get _inventory =>
      _firestore.collection('inventory');

  @override
  Future<Medicine?> getById(String id) async {
    final document = await _medicines.doc(id).get();
    return document.exists
        ? MedicineModel.fromFirestore(document).toEntity()
        : null;
  }

  @override
  Future<Medicine?> getByBarcode(String barcode) async {
    final normalized = barcode.trim();
    if (normalized.isEmpty) return null;
    final result = await _medicines
        .where('barcode', isEqualTo: normalized)
        .limit(1)
        .get();
    if (result.docs.isEmpty) return null;
    return MedicineModel.fromFirestore(result.docs.first).toEntity();
  }

  @override
  Future<List<Medicine>> getAll() async {
    final result = await _medicines.get();
    return result.docs
        .map((document) => MedicineModel.fromFirestore(document).toEntity())
        .toList(growable: false);
  }

  @override
  Future<List<Inventory>> getInventoryForUser(String userId) async {
    final result = await _inventory.where('userId', isEqualTo: userId).get();
    return result.docs
        .map((document) => InventoryModel.fromFirestore(document).toEntity())
        .toList(growable: false);
  }

  @override
  Future<Inventory?> getInventoryForMedicine({
    required String medicineId,
    required String userId,
  }) async {
    final result = await _inventory
        .where('medicineId', isEqualTo: medicineId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (result.docs.isEmpty) return null;
    return InventoryModel.fromFirestore(result.docs.first).toEntity();
  }
}
