import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class OrderCardHeader extends StatelessWidget {
  final OrderUiModel order;

  const OrderCardHeader({
    super.key,
    required this.order,
  });

  String _formatOrderTime(BuildContext context) {
    if (order.createdAtMillis == null) return '';
    final localeCode = Localizations.localeOf(context).languageCode;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(order.createdAtMillis!);
    return DateFormat('hh:mm a', localeCode).format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final timeStr = _formatOrderTime(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            size: 20,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.orderNumber}${order.orderId}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.bold16(context).copyWith(fontSize: 15),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    order.date,
                    style: AppStyles.regular12(context).copyWith(
                      color: secondary,
                      fontSize: 11,
                    ),
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
                        color: AppColors.accent,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}