import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../sales/domain/entities/sales_summary.dart';
import '../../../sales/domain/repositories/sales_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName = state.user?.displayName ?? 'أحمد';
        final roleLabel = state.user?.role ?? 'pharmacist';
        final userEmail = state.user?.email ?? 'user@medixa.com';
        final userId = state.user?.id ?? '';

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF3F7F9),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final pad = constraints.maxWidth > 480 ? 20.0 : 16.0;

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(pad, 12, pad, 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 10),
                            _PageHeader(
                              userName: userName,
                              role: roleLabel,
                              email: userEmail,
                              userId: userId,
                            ),
                            const SizedBox(height: 50),
                            _SummaryCard(userId: userId),
                            const SizedBox(height: 26),
                            const _MetricGrid(),
                            const SizedBox(height: 36),
                            const _QuickActionsGrid(),
                            const SizedBox(height: 16),
                            // const _AlertSection(),
                            const SizedBox(height: 16),
                            // const _RecentOrdersSection(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            //    bottomNavigationBar: const _BottomNavBar(),
          ),
        );
      },
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.userName,
    required this.role,
    required this.email,
    required this.userId,
  });

  final String userName;
  final String role;
  final String email;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final displayRole = role == 'admin' ? 'مدير' : 'صيدلي';

    return Row(
      children: [
        GestureDetector(
          onTap: () => _showUserProfile(
            context,
            userId: userId,
            fallbackName: userName,
            fallbackRole: role,
            fallbackEmail: email,
          ),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF5A3C62),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('👋', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3DAE9E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'مناوبة الصباح • $displayRole',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5A5A5A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.text,
            size: 22,
          ),
        ),
      ],
    );
  }
}

Future<void> _showUserProfile(
  BuildContext context, {
  required String userId,
  required String fallbackName,
  required String fallbackRole,
  required String fallbackEmail,
}) async {
  UserModel? profile;

  if (userId.isNotEmpty) {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        profile = UserModel.fromFirestore(snapshot);
      }
    } catch (_) {
      profile = null;
    }
  }

  if (!context.mounted) return;

  final name = profile?.name ?? fallbackName;
  final role = profile?.role ?? fallbackRole;
  final email = profile?.email.isNotEmpty == true
      ? profile!.email
      : fallbackEmail;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final displayRole = role == 'admin' ? 'مدير' : 'صيدلي';

      return Container(
        margin: const EdgeInsets.only(top: 36),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E5E7),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A3C62),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8F9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    displayRole,
                    style: const TextStyle(
                      color: Color(0xFF3A6C6E),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _ProfileInfoRow(label: ' : البريد الإلكتروني ', value: email),
                const SizedBox(height: 10),
                _ProfileInfoRow(label: ' : الدور', value: displayRole),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A3C62),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesSummary>(
      future: sl<SalesRepository>().getSummaryForUser(userId),
      builder: (context, snapshot) {
        final summary = snapshot.data;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFF4E7278), Color(0xFF5E8B8E)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'حركة المبيعات اليومية ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isLoading
                          ? 'جارٍ تحميل الفواتير...'
                          : '${summary?.completedInvoices ?? 0} فاتورة مكتملة',
                      style: const TextStyle(
                        color: Color(0xFFD7F1F2),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isLoading ? '...' : _formatPrice(summary?.totalPrice ?? 0),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'ر.س',
                    style: TextStyle(
                      color: Color(0xFFE5F7F7),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatPrice(double value) => value.toStringAsFixed(2);
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricCard(
        title: 'إجمالي المبيعات',
        value: '84,350',
        suffix: 'ر.س',
        icon: Icons.bar_chart_rounded,
        iconColor: const Color(0xFF3D8190),
        background: const Color(0xFFEAF8F9),
      ),
      _MetricCard(
        title: 'الإيرادات',
        value: '1,420',
        suffix: 'د.ا',
        icon: Icons.payments_rounded,
        iconColor: const Color(0xFF5F3D72),
        background: const Color(0xFFF4EDFA),
      ),
      _MetricCard(
        title: 'الطلبات',
        value: '8',
        suffix: 'أصناف',
        icon: Icons.local_pharmacy_rounded,
        iconColor: const Color(0xFF9B7B4E),
        background: const Color(0xFFF5F1EA),
      ),
      _MetricCard(
        title: 'المخزون',
        value: '14',
        suffix: 'منخفض',
        icon: Icons.inventory_2_rounded,
        iconColor: const Color(0xFF3A6C6E),
        background: const Color(0xFFEAF5F4),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.18,
      ),
      itemBuilder: (context, index) => metrics[index],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.suffix,
    required this.icon,
    required this.iconColor,
    required this.background,
  });

  final String title;
  final String value;
  final String suffix;
  final IconData icon;
  final Color iconColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Expanded(
                child: Text(
                  title,
                  // textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  color: AppColors.text,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  suffix,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'label': 'المساعد الذكي',
        'icon': Icons.medical_services_rounded,
        'color': const Color(0xFF5A3C62),
      },
      {
        'label': 'مسح باركود',
        'icon': Icons.qr_code_scanner_rounded,
        'color': const Color(0xFF34A6A0),
      },
      {
        'label': 'المخزون',
        'icon': Icons.inventory_2_outlined,
        'color': const Color(0xFF5A6A8C),
      },
      {
        'label': 'ملاحظات',
        'icon': Icons.add_rounded,
        'color': const Color(0xFF6D4C83),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final item = actions[index];
        final color = item['color'] as Color;

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: item['label'] == 'مسح باركود'
              ? () => Navigator.of(context).pushNamed(AppRouter.barcodeScanner)
              : item['label'] == 'المساعد الذكي'
              ? () => Navigator.of(context).pushNamed(AppRouter.drugAssistant)
              : item['label'] == 'المخزون'
              ? () => Navigator.of(context).pushNamed(AppRouter.inventory)
              : item['label'] == 'ملاحظات'
              ? () => Navigator.of(context).pushNamed(AppRouter.notes)
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['label'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AlertSection extends StatelessWidget {
  const _AlertSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'تنبيهات متعلقة بالمخزون',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFE58A39),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _MedicineAlertRow(
            title: 'بانادول ست',
            detail: 'باقي 20 وحدة فقط',
            tone: Color(0xFFFFF0D7),
            label: 'مهم',
          ),
          const SizedBox(height: 10),
          const _MedicineAlertRow(
            title: 'أمبروكسيل',
            detail: 'تاريخ انتهاء قريب',
            tone: Color(0xFFFFEAEA),
            label: 'حرج',
          ),
        ],
      ),
    );
  }
}

class _MedicineAlertRow extends StatelessWidget {
  const _MedicineAlertRow({
    required this.title,
    required this.detail,
    required this.tone,
    required this.label,
  });

  final String title;
  final String detail;
  final Color tone;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.text,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrdersSection extends StatelessWidget {
  const _RecentOrdersSection();

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'title': 'دواء 1', 'price': '128.50 ر.س'},
      {'title': 'دواء 2', 'price': '245.00 ر.س'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'آخر الطلبات',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        ...orders.map(
          (order) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x07000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2EEF6),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    order['title'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Text(
                  order['price'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.more_horiz_rounded),
        label: 'المزيد',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_rounded),
        label: 'الطلب',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded),
        label: 'الرئيسية',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2_rounded),
        label: 'المخزون',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_rounded),
        label: 'الملف',
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: items,
      ),
    );
  }
}
