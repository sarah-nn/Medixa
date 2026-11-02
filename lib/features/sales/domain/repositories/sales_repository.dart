import '../entities/sales_summary.dart';

abstract interface class SalesRepository {
  Future<SalesSummary> getSummaryForUser(String userId);
}
