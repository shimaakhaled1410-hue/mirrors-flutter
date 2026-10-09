import 'package:flutter/material.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import '../../../../core/utils/app_colors.dart';
import 'order_card_bottom_actions.dart';
import 'order_card_financial_summary.dart';
import 'order_card_header.dart';
import 'order_card_items_preview.dart';
import 'order_progress_stepper.dart';

class OrderCard extends StatelessWidget {
  final OrderUiModel order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final isCancelled = order.status == OrderStatus.cancelled;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderCardHeader(
            order: order,
          ),
          if (!isCancelled) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: OrderProgressStepper(currentStatus: order.status),
            ),
          ],
          const SizedBox(height: 12),
          OrderCardItemsPreview(
            order: order,
            isCancelled: isCancelled,
          ),
          const SizedBox(height: 12),
          OrderCardFinancialSummary(
            order: order,
            isCancelled: isCancelled,
          ),
          const SizedBox(height: 10),
          OrderCardBottomActions(
            isCancelled: isCancelled,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}