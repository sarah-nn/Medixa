import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  const Medicine({
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

  @override
  List<Object?> get props => [
    id,
    brandName,
    genericName,
    strength,
    dosageForm,
    manufacturer,
    category,
    barcode,
    imageUrl,
    activeIngredients,
    description,
    indications,
    dosageInstructions,
    patientAdvice,
    warnings,
    sideEffects,
    interactions,
    contraindications,
    storageInstructions,
    source,
    sourceUrl,
    isVerified,
    updatedAt,
  ];
}
