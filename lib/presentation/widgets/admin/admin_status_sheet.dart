import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../data/models/order_ui_model.dart';
import '../../../l10n/app_localizations.dart';

class AdminStatusSheet extends StatelessWidget {
  final OrderUiModel order;
  final ValueChanged<OrderStatus> onStatusSelected;

  const AdminStatusSheet({
    super.key,
    required this.order,
    required this.onStatusSelected,
  });

  String _getStatusName(OrderStatus status, AppLocalizations l10n) {
    switch (status) {
      case OrderStatus.received:
        return l10n.statusReceived;
      case OrderStatus.preparing:
        return l10n.statusPreparing;
      case OrderStatus.shipping:
        return l10n.statusShipping;
      case OrderStatus.delivered:
        return l10n.statusDelivered;
      case OrderStatus.cancelled:
        return l10n.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                _getStatusName(status, l10n),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.accent : null,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.accent)
                  : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onTap: () => onStatusSelected(status),
            );
          }),
        ],
      ),
    );
  }
}