import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../core/utils/app_styles.dart';
import '../../data/models/order_ui_model.dart';
import '../../data/services/orders_firestore_service.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/admin/admin_order_card.dart';
import '../widgets/admin/admin_order_filters_bar.dart';
import '../widgets/admin/admin_status_sheet.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({super.key});

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  final OrdersFirestoreService _firestoreService = OrdersFirestoreService();
  OrderStatus? _selectedFilter;

  Future<void> _makeCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phone, String orderId) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    final formattedPhone =
        cleanPhone.startsWith('0') ? '2$cleanPhone' : cleanPhone;
    final message = 'أهلاً بك، بخصوص طلبك رقم #$orderId من متجر المرايا:';
    final uri = Uri.parse(
        'https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showChangeStatusSheet(BuildContext context, OrderUiModel order) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AdminStatusSheet(
        order: order,
        onStatusSelected: (newStatus) async {
          sheetContext.pop();

          try {
            await _firestoreService.updateOrderStatus(order.orderId, newStatus);
            if (!mounted) return;
            AppSnackBar.showSuccess(
              this.context,
              message: l10n.statusUpdatedSuccess,
            );
          } catch (_) {
            if (!mounted) return;
            AppSnackBar.showError(
              this.context,
              message: l10n.statusUpdateFailed,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminOrdersTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          AdminOrderFiltersBar(
            selectedFilter: _selectedFilter,
            onFilterSelected: (filter) => setState(() => _selectedFilter = filter),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<OrderUiModel>>(
              stream: _firestoreService.getAllOrdersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                }

                final allOrders = snapshot.data ?? [];
                final filteredOrders = _selectedFilter == null
                    ? allOrders
                    : allOrders.where((o) => o.status == _selectedFilter).toList();

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Text(l10n.noOrdersYet, style: AppStyles.regular14(context)),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return AdminOrderCard(
                      order: order,
                      onCall: () => _makeCall(order.phoneNumber ?? ''),
                      onWhatsApp: () =>
                          _openWhatsApp(order.phoneNumber ?? '', order.orderId),
                      onChangeStatus: () => _showChangeStatusSheet(context, order),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}