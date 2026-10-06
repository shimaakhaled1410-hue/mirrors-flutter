import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../data/models/order_ui_model.dart';
import '../../../l10n/app_localizations.dart';

class AdminOrderFiltersBar extends StatelessWidget {
  final OrderStatus? selectedFilter;
  final ValueChanged<OrderStatus?> onFilterSelected;

  const AdminOrderFiltersBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          ChoiceChip(
            label: Text(l10n.allOrders),
            selected: selectedFilter == null,
            onSelected: (_) => onFilterSelected(null),
          ),
          const SizedBox(width: 8),
          ...OrderStatus.values.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(_getStatusName(status, l10n)),
                selected: selectedFilter == status,
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                onSelected: (val) => onFilterSelected(val ? status : null),
              ),
            );
          }),
        ],
      ),
    );
  }
}