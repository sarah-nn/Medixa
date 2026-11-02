import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/medicine.dart';

class MedicineModel {
  const MedicineModel({
    required this.id,
    required this.brandName,
    required this.genericName,
    required this.strength,
    required this.dosageForm,
    required this.manufacturer,
    required this.category,
    required this.barcode,
    required this.imageUrl,
    required this.activeIngredients,
    required this.description,
    required this.indications,
    required this.dosageInstructions,
    required this.patientAdvice,
    required this.warnings,
    required this.sideEffects,
    required this.interactions,
    required this.contraindications,
    required this.storageInstructions,
    required this.source,
    required this.sourceUrl,
    required this.isVerified,
    required this.updatedAt,
  });

  final String id;
  final String brandName;
  final String genericName;
  final String strength;
  final String dosageForm;
  final String manufacturer;
  final String category;
  final String barcode;
  final String imageUrl;
  final List<String> activeIngredients;
  final String description;
  final List<String> indications;
  final String dosageInstructions;
  final String patientAdvice;
  final List<String> warnings;
  final List<String> sideEffects;
  final List<String> interactions;
  final List<String> contraindications;
  final String storageInstructions;
  final String source;
  final String sourceUrl;
  final bool isVerified;
  final DateTime? updatedAt;

  factory MedicineModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};
    return MedicineModel(
      id: document.id,
      brandName: _string(data['brandName']),
      genericName: _string(data['genericName']),
      strength: _string(data['strength']),
      dosageForm: _string(data['dosageForm']),
      manufacturer: _string(data['manufacturer']),
      category: _string(data['category']),
      barcode: _string(data['barcode']),
      imageUrl: _string(data['imageUrl']),
      activeIngredients: _strings(data['activeIngredients']),
      description: _string(data['description']),
      indications: _strings(data['indications']),
      dosageInstructions: _string(data['dosageInstructions']),
      patientAdvice: _string(data['patientAdvice']),
      warnings: _strings(data['warnings']),
      sideEffects: _strings(data['sideEffects']),
      interactions: _strings(data['interactions']),
      contraindications: _strings(data['contraindications']),
      storageInstructions: _string(data['storageInstructions']),
      source: _string(data['source']),
      sourceUrl: _string(data['sourceUrl']),
      isVerified: data['isVerified'] == true,
      updatedAt: _date(data['updatedAt']),
    );
  }

  Medicine toEntity() => Medicine(
    id: id,
    brandName: brandName,
    genericName: genericName,
    strength: strength,
    dosageForm: dosageForm,
    manufacturer: manufacturer,
    category: category,
    barcode: barcode,
    imageUrl: imageUrl,
    activeIngredients: activeIngredients,
    description: description,
    indications: indications,
    dosageInstructions: dosageInstructions,
    patientAdvice: patientAdvice,
    warnings: warnings,
    sideEffects: sideEffects,
    interactions: interactions,
    contraindications: contraindications,
    storageInstructions: storageInstructions,
    source: source,
    sourceUrl: sourceUrl,
    isVerified: isVerified,
    updatedAt: updatedAt,
  );

  static String _string(Object? value) => value?.toString().trim() ?? '';

  static List<String> _strings(Object? value) {
    if (value is! Iterable) return const [];
    return value
        .whereType<Object>()
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  static DateTime? _date(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
