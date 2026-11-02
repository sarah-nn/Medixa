import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/inventory.dart';
import '../../domain/entities/medicine.dart';

class DrugDetailsPage extends StatelessWidget {
  const DrugDetailsPage({
    required this.medicine,
    required this.inventory,
    super.key,
  });

  final Medicine medicine;
  final Inventory? inventory;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6FAFD),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF6FAFD),
          foregroundColor: AppColors.text,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Medicine Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          leading: IconButton(
            tooltip: 'رجوع',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _IdentityCard(medicine: medicine),
              const SizedBox(height: 14),
              _InfoTiles(inventory: inventory),

              const SizedBox(height: 14),
              _ExpandableCard(
                icon: Icons.category_outlined,
                title: 'بيانات الدواء',
                child: Text(
                  'الشكل الدوائي: ${_valueOrFallback(medicine.dosageForm)}\n'
                  'الشركة المصنعة: ${_valueOrFallback(medicine.manufacturer)}\n'
                  'التصنيف: ${_valueOrFallback(medicine.category)}',
                  style: bodyStyle,
                ),
              ),
              const SizedBox(height: 12),
              _ExpandableCard(
                icon: Icons.menu_book_rounded,
                title: 'دواعي الاستعمال المصرحة',
                child: Text(
                  _listOrFallback(medicine.indications),
                  style: bodyStyle,
                ),
              ),
              const SizedBox(height: 12),
              _ExpandableCard(
                icon: Icons.schedule_rounded,
                title: 'تعليمات الجرعة النموذجية',
                child: Column(
                  children: [
                    Text(
                      _valueOrFallback(medicine.dosageInstructions),
                      style: bodyStyle,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'نصيحة الصيدلي للمريض: ',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            TextSpan(
                              text: _valueOrFallback(medicine.patientAdvice),
                            ),
                          ],
                        ),
                        style: bodyStyle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const SizedBox(height: 14),
              _WarningCard(medicine: medicine),
              const SizedBox(height: 12),
              _ExpandableCard(
                icon: Icons.info_outline_rounded,
                title: 'المعلومات الطبية الإضافية',
                child: Text(
                  'الآثار الجانبية: ${_listOrFallback(medicine.sideEffects)}\n\n'
                  'التداخلات: ${_listOrFallback(medicine.interactions)}\n\n'
                  'التخزين: ${_valueOrFallback(medicine.storageInstructions)}\n\n'
                  'سعر الشراء: ${_formatPrice(inventory?.purchasePrice)}\n'
                  'الحد الأدنى للمخزون: ${inventory?.minStockLevel.toString() ?? 'غير متوفر'}',
                  style: bodyStyle,
                ),
              ),
              const SizedBox(height: 12),
              _ExpandableCard(
                icon: Icons.local_hospital_outlined,
                title: 'نصيحة الصيدلي للمريض',
                child: Text(
                  _valueOrFallback(medicine.patientAdvice),
                  style: bodyStyle,
                ),
              ),
              const SizedBox(height: 12),
              _ExpandableCard(
                icon: Icons.source_outlined,
                title: 'المصدر',
                child: Text(
                  '${_valueOrFallback(medicine.source)}\n'
                  '${_valueOrFallback(medicine.sourceUrl)}',
                  style: bodyStyle,
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: const [
              //     Text(
              //       'البدائل المتوفرة بالصيدلية',
              //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              //     ),
              //     Text(
              //       'نفس المادة الفعالة',
              //       style: TextStyle(
              //         color: Color(0xFF3A6C6E),
              //         fontSize: 11,
              //         fontWeight: FontWeight.w700,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 10),
              //const _AlternativeCard(),
              //const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

const bodyStyle = TextStyle(
  color: Color(0xFF34383B),
  fontSize: 14,
  height: 1.65,
);

String _valueOrFallback(String value) =>
    value.trim().isEmpty ? 'غير متوفر' : value.trim();

String _listOrFallback(List<String> values) =>
    values.isEmpty ? 'غير متوفر' : values.join('، ');

String _formatPrice(double? value) =>
    value == null ? 'غير متوفر' : '${value.toStringAsFixed(2)} ر.س';

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: const [
                        _Tag(
                          text: 'مسجل بوزارة الصحة',
                          color: Color(0xFFBAECEE),
                        ),
                        _Tag(
                          text: 'مضاد حيوي واسع المجال',
                          color: Color(0xFFE5E9EC),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      medicine.brandName,
                      style: const TextStyle(
                        color: Color(0xFF42264A),
                        fontSize: 22,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      medicine.genericName,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 72,
                height: 78,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF3F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: medicine.imageUrl.isEmpty
                    ? const Icon(
                        Icons.medication_rounded,
                        size: 36,
                        color: AppColors.primary,
                      )
                    : Image.network(
                        medicine.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, stackTrace) => const Icon(
                          Icons.medication_rounded,
                          size: 36,
                          color: AppColors.primary,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'المادة الفعالة والتركيز:',
                  style: TextStyle(
                    color: Color(0xFF366668),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _listOrFallback(medicine.activeIngredients),
                  style: bodyStyle,
                ),
                Text(
                  _valueOrFallback(medicine.strength),
                  textDirection: TextDirection.ltr,
                  style: bodyStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _BarcodeValue(
                  label: 'الباركود الدولي (GTIN)',
                  value: _valueOrFallback(medicine.barcode),
                ),
              ),
              // FilledButton.icon(
              //   onPressed: () {},
              //   icon: const Icon(Icons.qr_code_scanner_rounded, size: 17),
              //   label: const Text('تحقق'),
              //   style: FilledButton.styleFrom(
              //     backgroundColor: const Color(0xFFBAECEE),
              //     foregroundColor: const Color(0xFF1B4E50),
              //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _BarcodeValue extends StatelessWidget {
  const _BarcodeValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            fontSize: 15,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _InfoTiles extends StatelessWidget {
  const _InfoTiles({required this.inventory});

  final Inventory? inventory;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            label: 'الرصيد المتاح',
            value: inventory?.quantity.toString() ?? 'غير',
            suffix: 'علبة',
            icon: Icons.circle,
            color: const Color(0xFF3A6C6E),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InfoTile(
            label: 'سعر البيع',
            value: inventory == null
                ? 'غير'
                : inventory!.sellingPrice.toStringAsFixed(2),
            suffix: 'ر.س',
            icon: Icons.payments_outlined,
            color: const Color(0xFF5A3C62),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InfoTile(
            label: 'الصلاحية',
            value: _formatDate(inventory?.expiryDate),
            suffix: 'تاريخ الانتهاء',
            icon: Icons.calendar_month_outlined,
            color: const Color(0xFF3A6C6E),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'غير';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}';
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.suffix,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String suffix;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            suffix,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.medicine});

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFBA1A1A),
            size: 38,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تنبيه تحذيري: موانع الاستعمال\nقصوى',
                  style: TextStyle(
                    color: Color(0xFF93000A),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  _listOrFallback([
                    ...medicine.warnings,
                    ...medicine.contraindications,
                  ]),
                  style: TextStyle(
                    color: Color(0xFF93000A),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableCard extends StatelessWidget {
  const _ExpandableCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF5A3C62)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
