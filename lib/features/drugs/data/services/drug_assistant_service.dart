import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/inventory.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medicine_repository.dart';

class DrugAssistantService {
  DrugAssistantService(this._repository, this._auth, FirebaseAI? firebaseAI)
    : _firebaseAI = firebaseAI ?? FirebaseAI.googleAI();

  final MedicineRepository _repository;
  final FirebaseAuth _auth;
  final FirebaseAI _firebaseAI;

  Future<String> ask(String question, List<String> history) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return _safe('غير مصادق', 'يجب تسجيل الدخول لاستخدام المساعد الدوائي.');
    }

    final medicines = await _repository.getAll();
    final inventories = await _repository.getInventoryForUser(userId);
    final context = _buildContext(medicines, inventories);
    final model = _firebaseAI.generativeModel(
      model: 'gemini-3.8-flash',
      systemInstruction: Content.system(_systemInstruction),
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 700,
        responseMimeType: 'application/json',
      ),
    );
    final prompt = '''
DATABASE CONTEXT:
$context

RECENT CONVERSATION:
${history.take(6).join('\n')}

PHARMACIST QUESTION:
$question

Return only JSON with keys: answer, status, sourceMedicineIds,
sourceFieldNames, missingInformation.
''';
    final response = await model.generateContent([Content.text(prompt)]);
    final raw = response.text?.trim();
    if (raw == null || raw.isEmpty) {
      return _safe('رد غير صالح', 'تعذر الحصول على رد صالح من المساعد.');
    }
    return _validate(raw, medicines);
  }

  String _buildContext(
    List<Medicine> medicines,
    List<Inventory> inventories,
  ) {
    final inventoryByMedicine = <String, Inventory>{
      for (final item in inventories) item.medicineId: item,
    };
    return jsonEncode(
      medicines
          .map(
            (medicine) => {
              'medicineId': medicine.id,
              'brandName': medicine.brandName,
              'genericName': medicine.genericName,
              'strength': medicine.strength,
              'dosageForm': medicine.dosageForm,
              'manufacturer': medicine.manufacturer,
              'category': medicine.category,
              'barcode': medicine.barcode,
              'activeIngredients': medicine.activeIngredients,
              'description': medicine.description,
              'indications': medicine.indications,
              'dosageInstructions': medicine.dosageInstructions,
              'patientAdvice': medicine.patientAdvice,
              'warnings': medicine.warnings,
              'sideEffects': medicine.sideEffects,
              'interactions': medicine.interactions,
              'contraindications': medicine.contraindications,
              'storageInstructions': medicine.storageInstructions,
              'source': medicine.source,
              'sourceUrl': medicine.sourceUrl,
              'isVerified': medicine.isVerified,
              'inventory': inventoryByMedicine[medicine.id] == null
                  ? null
                  : {
                      'inventoryId': inventoryByMedicine[medicine.id]!.id,
                      'quantity': inventoryByMedicine[medicine.id]!.quantity,
                      'minStockLevel':
                          inventoryByMedicine[medicine.id]!.minStockLevel,
                      'purchasePrice':
                          inventoryByMedicine[medicine.id]!.purchasePrice,
                      'sellingPrice':
                          inventoryByMedicine[medicine.id]!.sellingPrice,
                      'expiryDate': inventoryByMedicine[medicine.id]!
                          .expiryDate
                          ?.toIso8601String(),
                    },
            },
          )
          .toList(),
    );
  }

  String _validate(
    String raw,
    List<Medicine> medicines,
  ) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic> || decoded['answer'] is! String) {
        return _safe('رد غير صالح', 'تعذر التحقق من رد المساعد.');
      }
      final ids = (decoded['sourceMedicineIds'] as List? ?? const [])
          .whereType<String>()
          .toList();
      final fields = (decoded['sourceFieldNames'] as List? ?? const [])
          .whereType<String>()
          .toList();
      final validIds = medicines.map((item) => item.id).toSet();
      if (ids.any((id) => !validIds.contains(id))) {
        return _safe('مرجع غير صالح', 'تعذر التحقق من مصادر رد المساعد.');
      }
      final allowedFields = <String>{
        'brandName', 'genericName', 'strength', 'dosageForm', 'manufacturer',
        'category', 'barcode', 'activeIngredients', 'description',
        'indications', 'dosageInstructions', 'patientAdvice', 'warnings',
        'sideEffects', 'interactions', 'contraindications',
        'storageInstructions', 'source', 'sourceUrl', 'isVerified',
        'quantity', 'minStockLevel', 'purchasePrice', 'sellingPrice',
        'expiryDate',
      };
      if (fields.any((field) => !allowedFields.contains(field))) {
        return _safe('مرجع غير صالح', 'تعذر التحقق من مصادر رد المساعد.');
      }
      if (decoded['answer'].toString().trim().isEmpty) {
        return _safe('معلومات غير كافية', 'لا توجد معلومات كافية في قاعدة البيانات.');
      }
      return decoded['answer'].toString();
    } on FormatException {
      return _safe('رد غير صالح', 'تعذر التحقق من رد المساعد.');
    } catch (_) {
      return _safe('رد غير صالح', 'تعذر التحقق من رد المساعد.');
    }
  }

  String _safe(String status, String answer) => answer;

  static const _systemInstruction = '''
You are MediXa Drug Assistant. Answer ONLY from the Firestore context in the
current request. Never use general medical knowledge or invent information.
If the medicine is not present, say: عذراً، ما عندي معلومات كافية عن هاد الدواء ضمن قاعدة بيانات MediXa.
If requested data is missing, say: الدواء موجود بقاعدة البيانات، لكن المعلومات المطلوبة غير متوفرة حالياً.
Never guess dosage, diagnose, or advise stopping treatment. Answer in the
pharmacist's language, prefer clear Syrian/Levantine Arabic for Arabic.
Return only valid JSON with answer, status, sourceMedicineIds, sourceFieldNames,
and missingInformation.
''';
}
