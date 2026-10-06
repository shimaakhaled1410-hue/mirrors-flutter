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
                label: Text(status.localizedName(l10n)),
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