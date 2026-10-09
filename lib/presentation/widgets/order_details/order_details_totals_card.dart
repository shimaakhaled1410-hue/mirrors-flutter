import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../data/models/order_ui_model.dart';
import '../../../l10n/app_localizations.dart';

class OrderDetailsTotalsCard extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsTotalsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCancelled = order.status == OrderStatus.cancelled;
    final isDelivered = order.status == OrderStatus.delivered;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.total, style: AppStyles.semiBold16(context)),
              Text(
                '${order.totalPrice.toInt()} ${l10n.egp}',
                style: AppStyles.bold16(context).copyWith(
                  decoration: isCancelled ? TextDecoration.lineThrough : null,
                  color: isCancelled ? secondary : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.depositPaidLabel, style: AppStyles.regular14(context)),
              Text(
                '${order.depositAmount.toInt()} ${l10n.egp}',
                style: AppStyles.bold16Accent.copyWith(
                  color: isCancelled ? secondary : null,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.remainingOnDelivery,
                style: AppStyles.semiBold16(context).copyWith(
                  color: isCancelled
                      ? secondary
                      : (isDelivered ? const Color(0xFF389E0D) : Colors.green),
                ),
              ),
              Text(
                isCancelled
                    ? '0 ${l10n.egp}'
                    : (isDelivered
                        ? '0 ${l10n.egp}'
                        : '${order.remainingAmount.toInt()} ${l10n.egp}'),
                style: AppStyles.bold18(context).copyWith(
                  color: isCancelled
                      ? secondary
                      : (isDelivered ? const Color(0xFF389E0D) : Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}