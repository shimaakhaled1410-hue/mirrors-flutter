import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../core/utils/app_styles.dart';
import '../../data/models/order_ui_model.dart';
import '../../data/services/orders_firestore_service.dart';
import '../../l10n/app_localizations.dart';

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
    final formattedPhone = cleanPhone.startsWith('0')
        ? '2$cleanPhone'
        : cleanPhone;
    final message = 'أهلاً بك، بخصوص طلبك رقم #$orderId من متجر المرايا:';
    final uri = Uri.parse(
      'https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showChangeStatusSheet(
    BuildContext context,
    OrderUiModel order,
    AppLocalizations l10n,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${l10n.changeStatus} (#${order.orderId})',
                textAlign: TextAlign.center,
                style: AppStyles.bold18(context),
              ),
              const SizedBox(height: 16),
              ...OrderStatus.values.map((status) {
                final isSelected = order.status == status;
                return ListTile(
                  title: Text(
                    status.name,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? AppColors.accent : null,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.accent,
                        )
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _firestoreService.updateOrderStatus(
                      order.orderId,
                      status,
                    );
                    if (context.mounted) {
                      AppSnackBar.showSuccess(
                        context,
                        message: l10n.statusUpdatedSuccess,
                      );
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminOrdersTitle), centerTitle: true),
      body: Column(
        children: [
          // Filter horizontal list
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text(l10n.allOrders),
                  selected: _selectedFilter == null,
                  onSelected: (_) => setState(() => _selectedFilter = null),
                ),
                const SizedBox(width: 8),
                ...OrderStatus.values.map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status.name),
                      selected: _selectedFilter == status,
                      onSelected: (val) =>
                          setState(() => _selectedFilter = val ? status : null),
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(height: 1),

          // Orders Stream List
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
                    : allOrders
                          .where((o) => o.status == _selectedFilter)
                          .toList();

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noOrdersYet,
                      style: AppStyles.regular14(context),
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];

                    return Card(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order ID & Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '#${order.orderId}',
                                  style: AppStyles.bold16(context),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    order.status.name,
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Customer Details
                            Text(
                              '${order.customerName ?? '-'} • ${order.phoneNumber ?? '-'}',
                              style: AppStyles.semiBold14(context),
                            ),
                            if (order.address != null &&
                                order.address!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                order.address!,
                                style: AppStyles.regular12(context),
                              ),
                            ],
                            const SizedBox(height: 10),
                            const Divider(height: 1),
                            const SizedBox(height: 10),

                            // Financials
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${l10n.depositPaidLabel}: ${order.depositAmount.toInt()} EGP',
                                  style: AppStyles.regular12(context),
                                ),
                                Text(
                                  '${l10n.remainingToPay}: ${order.remainingAmount.toInt()} EGP',
                                  style: AppStyles.bold14(
                                    context,
                                  ).copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Action buttons
                            Row(
                              children: [
                                if (order.phoneNumber != null &&
                                    order.phoneNumber!.isNotEmpty) ...[
                                  IconButton.filledTonal(
                                    onPressed: () =>
                                        _makeCall(order.phoneNumber!),
                                    icon: const Icon(
                                      Icons.phone_rounded,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton.filledTonal(
                                    onPressed: () => _openWhatsApp(
                                      order.phoneNumber!,
                                      order.orderId,
                                    ),
                                    icon: const Icon(
                                      Icons.chat_bubble_rounded,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _showChangeStatusSheet(
                                      context,
                                      order,
                                      l10n,
                                    ),
                                    child: Text(l10n.changeStatus),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
