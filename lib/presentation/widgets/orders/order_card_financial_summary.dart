import 'package:flutter/material.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class OrderCardFinancialSummary extends StatelessWidget {
  final OrderUiModel order;
  final bool isCancelled;

  const OrderCardFinancialSummary({
    super.key,
    required this.order,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground.withValues(alpha: 0.3)
            : AppColors.lightBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.total,
                style: AppStyles.regular12(
                  context,
                ).copyWith(fontSize: 11, color: secondary),
              ),
              const SizedBox(height: 2),
              Text(
                '${order.totalPrice.toInt()} ${l10n.egp}',
                style: AppStyles.bold16(context).copyWith(
                  fontSize: 14,
                  color: isCancelled ? secondary : AppColors.accent,
                  decoration: isCancelled
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
          if (!isCancelled && order.remainingAmount > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.remainingOnDelivery,
                  style: AppStyles.regular12(
                    context,
                  ).copyWith(fontSize: 11, color: secondary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${order.remainingAmount.toInt()} ${l10n.egp}',
                  style: AppStyles.bold16(
                    context,
                  ).copyWith(fontSize: 14, color: const Color(0xFF2E7D32)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
