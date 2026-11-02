import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/inventory.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medicine_repository.dart';
import 'drug_details_page.dart';

class InventoryOverviewPage extends StatelessWidget {
  const InventoryOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userId = state.user?.id ?? '';

        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF3F7F9),
            appBar: AppBar(
              backgroundColor: const Color(0xFFF3F7F9),
              foregroundColor: AppColors.text,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'نظرة عامة على المخزون',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              leading: IconButton(
                tooltip: 'رجوع',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ),
            body: userId.isEmpty
                ? const _InventoryMessage(
                    icon: Icons.person_outline_rounded,
                    message: 'تعذر تحديد المستخدم الحالي.',
                  )
                : FutureBuilder<_InventoryOverviewData>(
                    future: _loadOverview(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const _InventoryMessage(
                          icon: Icons.cloud_off_rounded,
                          message: 'تعذر تحميل بيانات المخزون. حاول مرة أخرى.',
                        );
                      }

                      final data = snapshot.data;
                      if (data == null || data.entries.isEmpty) {
                        return const _InventoryMessage(
                          icon: Icons.inventory_2_outlined,
                          message: 'لا توجد أدوية مضافة إلى المخزون بعد.',
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        children: [
                          _OverviewSummary(data: data),
                          const SizedBox(height: 18),
                          const Text(
                            'جميع الأدوية',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...data.entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _InventoryMedicineCard(entry: entry),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

Future<_InventoryOverviewData> _loadOverview(String userId) async {
  final repository = sl<MedicineRepository>();
  final results = await Future.wait([
    repository.getInventoryForUser(userId),
    repository.getAll(),
  ]);
  final inventories = results[0] as List<Inventory>;
  final medicines = results[1] as List<Medicine>;
  final medicinesById = {
    for (final medicine in medicines) medicine.id: medicine,
  };

  final entries =
      inventories
          .map(
            (inventory) => _InventoryEntry(
              inventory: inventory,
              medicine: medicinesById[inventory.medicineId],
            ),
          )
          .toList()
        ..sort((first, second) {
          final firstLow = first.isLowStock ? 0 : 1;
          final secondLow = second.isLowStock ? 0 : 1;
          if (firstLow != secondLow) return firstLow.compareTo(secondLow);
          return first.displayName.compareTo(second.displayName);
        });

  return _InventoryOverviewData(entries);
}

class _InventoryOverviewData {
  const _InventoryOverviewData(this.entries);

  final List<_InventoryEntry> entries;

  int get totalQuantity =>
      entries.fold(0, (total, entry) => total + entry.inventory.quantity);

  int get lowStockCount => entries.where((entry) => entry.isLowStock).length;

  int get expiringSoonCount => entries.where((entry) {
    final expiryDate = entry.inventory.expiryDate;
    if (expiryDate == null) return false;
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    return !expiryDate.isBefore(dateOnly) &&
        expiryDate.isBefore(dateOnly.add(const Duration(days: 30)));
  }).length;

  double get totalValue => entries.fold(
    0,
    (total, entry) =>
        total + entry.inventory.quantity * entry.inventory.purchasePrice,
  );
}

class _InventoryEntry {
  const _InventoryEntry({required this.inventory, required this.medicine});

  final Inventory inventory;
  final Medicine? medicine;

  bool get isLowStock => inventory.quantity <= inventory.minStockLevel;

  String get displayName {
    final brandName = medicine?.brandName.trim() ?? '';
    if (brandName.isNotEmpty) return brandName;
    final genericName = medicine?.genericName.trim() ?? '';
    if (genericName.isNotEmpty) return genericName;
    return 'دواء غير معروف';
  }

  String get subtitle {
    final parts = [
      medicine?.genericName.trim() ?? '',
      medicine?.strength.trim() ?? '',
    ].where((part) => part.isNotEmpty).toList();
    return parts.isEmpty
        ? 'معرف الدواء: ${inventory.medicineId}'
        : parts.join(' • ');
  }
}

class _OverviewSummary extends StatelessWidget {
  const _OverviewSummary({required this.data});

  final _InventoryOverviewData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                label: 'عدد الأدوية',
                value: '${data.entries.length}',
                icon: Icons.medication_outlined,
                color: const Color(0xFF5A3C62),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryTile(
                label: 'إجمالي الوحدات',
                value: '${data.totalQuantity}',
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFF3A6C6E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _SummaryTile(
                label: 'مخزون منخفض',
                value: '${data.lowStockCount}',
                icon: Icons.warning_amber_rounded,
                color: const Color(0xFFB36A3B),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryTile(
                label: 'تنتهي خلال 30 يوم',
                value: '${data.expiringSoonCount}',
                icon: Icons.event_busy_outlined,
                color: const Color(0xFF7C5A8E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: AppColors.accent,
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                'قيمة الشراء التقديرية',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${data.totalValue.toStringAsFixed(2)} ر.س',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
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

class _InventoryMedicineCard extends StatelessWidget {
  const _InventoryMedicineCard({required this.entry});

  final _InventoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final inventory = entry.inventory;
    final expiryDate = inventory.expiryDate;
    final statusColor = entry.isLowStock
        ? const Color(0xFFB36A3B)
        : const Color(0xFF3A8C7A);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: entry.medicine == null
            ? null
            : () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => DrugDetailsPage(
                    medicine: entry.medicine!,
                    inventory: inventory,
                  ),
                ),
              ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5F4),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.medication_rounded,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          entry.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (entry.medicine != null)
                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 15,
                      color: AppColors.muted,
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _DetailValue(
                    label: 'الكمية',
                    value: '${inventory.quantity}',
                    valueColor: statusColor,
                  ),
                  _DetailValue(
                    label: 'الحد الأدنى',
                    value: '${inventory.minStockLevel}',
                  ),
                  _DetailValue(
                    label: 'سعر البيع',
                    value: '${inventory.sellingPrice.toStringAsFixed(2)} ر.س',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: entry.isLowStock
                      ? const Color(0xFFFFF3E9)
                      : const Color(0xFFEDF8F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      entry.isLowStock
                          ? Icons.warning_amber_rounded
                          : Icons.event_available_outlined,
                      size: 17,
                      color: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        entry.isLowStock
                            ? 'تنبيه: الكمية وصلت إلى الحد الأدنى'
                            : expiryDate == null
                            ? 'تاريخ الانتهاء غير متوفر'
                            : 'تاريخ الانتهاء: ${DateFormat('d MMM yyyy', 'ar').format(expiryDate)}',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailValue extends StatelessWidget {
  const _DetailValue({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor ?? AppColors.text,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryMessage extends StatelessWidget {
  const _InventoryMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.muted, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
