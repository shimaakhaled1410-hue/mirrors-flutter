import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../data/models/order_ui_model.dart';
import '../../../../l10n/app_localizations.dart';
import 'order_details_info_row.dart';

class OrderDetailsShippingCard extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsShippingCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(l10n.shippingDetails, style: AppStyles.semiBold16(context)),
            ],
          ),
          const SizedBox(height: 14),
          OrderDetailsInfoRow(
            label: l10n.fullName,
            value: order.customerName?.isNotEmpty == true
                ? order.customerName!
                : l10n.notRegistered,
          ),
          const Divider(height: 16),
          OrderDetailsInfoRow(
            label: l10n.phoneNumber,
            value: order.phoneNumber?.isNotEmpty == true
                ? order.phoneNumber!
                : l10n.notRegistered,
          ),
          const Divider(height: 16),
          OrderDetailsInfoRow(
            label: l10n.address,
            value: order.address?.isNotEmpty == true
                ? order.address!
                : l10n.notRegistered,
          ),
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            const Divider(height: 16),
            OrderDetailsInfoRow(label: l10n.deliveryNotes, value: order.notes!),
          ],
        ],
      ),
    );
  }
}
