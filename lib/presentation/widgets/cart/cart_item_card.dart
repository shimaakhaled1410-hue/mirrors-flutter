import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/mirror_ui_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Icon representation of the product
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.product.category == MirrorCategory.framed
                  ? Icons.crop_portrait_rounded
                  : Icons.layers_rounded,
              color: AppColors.accent,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),

          // Details: Dimensions, Type, and Total Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.product.dimensions} ${l10n.cm}',
                  style: AppStyles.semiBold16(context),
                ),
                const SizedBox(height: 2),
                Text(
                  item.isWholesale ? l10n.wholesaleTab : l10n.retailTab,
                  style: AppStyles.regular12(context),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.totalPrice.toInt()} ${l10n.egp}',
                  style: AppStyles.bold16Accent,
                ),
              ],
            ),
          ),

          // Counter Controls & Remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                onPressed: onRemove,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCountBtn(
                    context,
                    icon: Icons.remove,
                    onTap: onDecrement,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${item.quantity}',
                      style: AppStyles.semiBold16(context).copyWith(fontSize: 14),
                    ),
                  ),
                  _buildCountBtn(
                    context,
                    icon: Icons.add,
                    onTap: onIncrement,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountBtn(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}