import '../entities/inventory.dart';
import '../entities/medicine.dart';

abstract interface class MedicineRepository {
  Future<Medicine?> getById(String id);
  Future<Medicine?> getByBarcode(String barcode);
  Future<List<Medicine>> getAll();
  Future<List<Inventory>> getInventoryForUser(String userId);
  Future<Inventory?> getInventoryForMedicine({
    required String medicineId,
    required String userId,
  });
}
