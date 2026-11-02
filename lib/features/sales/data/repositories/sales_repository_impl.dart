import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/sales_summary.dart';
import '../../domain/repositories/sales_repository.dart';

class SalesRepositoryImpl implements SalesRepository {
  SalesRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<SalesSummary> getSummaryForUser(String userId) async {
    if (userId.trim().isEmpty) {
      return const SalesSummary(completedInvoices: 0, totalPrice: 0);
    }

    final result = await _firestore
        .collection('sales')
        .where('userId', isEqualTo: userId)
        .get();

    var totalPrice = 0.0;
    for (final document in result.docs) {
      final data = document.data();
      final saleDate = _date(data['createdAt'] ?? data['date']);
      if (saleDate != null && !_isToday(saleDate)) continue;
      totalPrice += _number(data['price'] ?? data['totalPrice']);
    }

    final completedInvoices = result.docs.where((document) {
      final data = document.data();
      final saleDate = _date(data['createdAt'] ?? data['date']);
      return saleDate == null || _isToday(saleDate);
    }).length;

    return SalesSummary(
      completedInvoices: completedInvoices,
      totalPrice: totalPrice,
    );
  }

  double _number(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  DateTime? _date(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.tryParse(value?.toString() ?? '');
  }

  bool _isToday(DateTime value) {
    final date = value.toLocal();
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }
}
