import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../data/models/mirror_ui_model.dart';
import '../../../../data/models/order_ui_model.dart';
import '../../../../l10n/app_localizations.dart';

class OrderDetailsItemsCard extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsItemsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

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
                Icons.inventory_2_outlined,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.itemsCountTitle(order.totalItems),
                style: AppStyles.semiBold16(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) {
            final categoryTitle = item.product.category == MirrorCategory.framed
                ? l10n.framedMirrors
                : l10n.adhesiveMirrors;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.crop_portrait_rounded,
                      color: AppColors.accent,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.mirrorUnitDimensions(item.product.dimensions),
                          style: AppStyles.semiBold16(
                            context,
                          ).copyWith(fontSize: 14),
                        ),
                        Text(
                          '$categoryTitle • ${l10n.quantity}: ${item.quantity}',
                          style: AppStyles.regular12(
                            context,
                          ).copyWith(color: secondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${item.totalPrice.toInt()} ${l10n.egp}',
                    style: AppStyles.bold16(context).copyWith(fontSize: 14),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
