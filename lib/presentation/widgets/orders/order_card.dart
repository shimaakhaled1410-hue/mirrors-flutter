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
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  size: 18,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${l10n.orderNumber}${order.orderId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.semiBold16(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: border),
                ),
                child: Text(order.date, style: AppStyles.regular12(context)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 16, color: secondary),
              const SizedBox(width: 6),
              Text(
                '${order.totalItems} ${l10n.items}',
                style: AppStyles.regular14(context),
              ),
              const SizedBox(width: 8),
              Text('•', style: AppStyles.regular14(context)),
              const SizedBox(width: 8),
              Text(
                '${order.totalPrice.toInt()} ${l10n.egp}',
                style: AppStyles.bold16Accent,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.fromLTRB(4, 14, 4, 10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            child: OrderProgressStepper(currentStatus: order.status),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: onTap,
              iconAlignment: IconAlignment.end,
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                // matchTextDirection: true,
              ),
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