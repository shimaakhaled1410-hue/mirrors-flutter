import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../data/models/order_ui_model.dart';
import '../../../l10n/app_localizations.dart';
import '../orders/order_progress_stepper.dart';

class OrderDetailsStatusCard extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsStatusCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCancelled = order.status == OrderStatus.cancelled;
    final isDelivered = order.status == OrderStatus.delivered;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCancelled
              ? (isDark
                    ? Colors.red.withValues(alpha: 0.3)
                    : const Color(0xFFFFA39E))
              : (isDelivered
                    ? (isDark
                          ? Colors.green.withValues(alpha: 0.3)
                          : const Color(0xFFB7EB8F))
                    : border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCancelled
                    ? l10n.statusCancelled
                    : (isDelivered
                          ? l10n.statusDelivered
                          : l10n.orderTrackingTitle),
                style: AppStyles.semiBold16(context).copyWith(
                  color: isCancelled
                      ? const Color(0xFFCF1322)
                      : (isDelivered ? const Color(0xFF389E0D) : null),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Text(order.date, style: AppStyles.regular12(context)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isCancelled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.red.withValues(alpha: 0.08)
                    : const Color(0xFFFFF1F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.red.withValues(alpha: 0.2)
                      : const Color(0xFFFFCCC7),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFCF1322),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.statusCancelled,
                      style: AppStyles.medium14(
                        context,
                      ).copyWith(color: const Color(0xFFCF1322), fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          else if (isDelivered)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.green.withValues(alpha: 0.08)
                    : const Color(0xFFF6FFED),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.green.withValues(alpha: 0.2)
                      : const Color(0xFFD9F7BE),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF389E0D),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.statusDelivered,
                      style: AppStyles.medium14(
                        context,
                      ).copyWith(color: const Color(0xFF389E0D), fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: OrderProgressStepper(currentStatus: order.status),
            ),
        ],
      ),
    );
  }
}
