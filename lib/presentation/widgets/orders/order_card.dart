import 'package:flutter/material.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import 'order_progress_stepper.dart';

class OrderCard extends StatelessWidget {
  final OrderUiModel order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${l10n.orderNumber}${order.orderId}',
                style: AppStyles.semiBold16(context),
              ),
              Text(order.date, style: AppStyles.regular12(context)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${order.totalItems} ${l10n.items}  •  ${order.totalPrice.toInt()} ${l10n.egp}',
            style: AppStyles.bold16Accent,
          ),
          const SizedBox(height: 16),
          // Progress Stepper
          OrderProgressStepper(currentStatus: order.status),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 8),
          // Footer button
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              label: Text(
                l10n.viewDetails,
                style: AppStyles.semiBold16(
                  context,
                ).copyWith(fontSize: 12, color: AppColors.primaryLight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
