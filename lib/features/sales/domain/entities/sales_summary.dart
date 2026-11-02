import 'package:equatable/equatable.dart';

class SalesSummary extends Equatable {
  const SalesSummary({
    required this.completedInvoices,
    required this.totalPrice,
  });

  final int completedInvoices;
  final double totalPrice;

  @override
  List<Object> get props => [completedInvoices, totalPrice];
}
