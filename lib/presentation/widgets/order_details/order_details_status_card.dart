import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../data/models/order_ui_model.dart';
import '../../../l10n/app_localizations.dart';
import '../orders/order_progress_stepper.dart';

class OrderDetailsStatusCard extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsStatusCard({super.key, required this.order});

  String _formatOrderTime(BuildContext context) {
    if (order.createdAtMillis == null) return '';
    final localeCode = Localizations.localeOf(context).languageCode;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      order.createdAtMillis!,
    );
    return DateFormat('hh:mm a', localeCode).format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCancelled = order.status == OrderStatus.cancelled;
    final isDelivered = order.status == OrderStatus.delivered;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final timeStr = _formatOrderTime(context);

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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      order.date,
                      style: AppStyles.regular12(
                        context,
                      ).copyWith(fontSize: 11),
                    ),
                    if (timeStr.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '•',
                          style: TextStyle(color: secondary, fontSize: 10),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: AppStyles.medium14(context).copyWith(
                          color: isCancelled
                              ? const Color(0xFFCF1322)
                              : AppColors.accent,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFCF1322),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.statusCancelled,
                          style: AppStyles.semiBold16(context).copyWith(
                            color: const Color(0xFFCF1322),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.orderCancelledRefundNote,
                          style: AppStyles.regular12(context).copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : const Color(0xFF595959),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
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
