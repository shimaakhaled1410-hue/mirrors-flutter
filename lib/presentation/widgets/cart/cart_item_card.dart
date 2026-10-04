import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/mirror_ui_model.dart';
import '../catalog/components/zoomable_image_dialog.dart';

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
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final heroTag = 'cart_mirror_zoom_${item.id}';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (item.product.imagePlaceholder != null) {
                ZoomableImageDialog.show(
                  context,
                  imagePath: item.product.imagePlaceholder!,
                  heroTag: heroTag,
                );
              }
            },
            child: Container(
              width: 54,
              height: 72,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1724)
                    : const Color(0xFFFAF9FB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: item.product.imagePlaceholder != null
                  ? Hero(
                      tag: heroTag,
                      child: Image.asset(
                        item.product.imagePlaceholder!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Icon(
                      item.product.category == MirrorCategory.framed
                          ? Icons.crop_portrait_rounded
                          : Icons.layers_rounded,
                      color: AppColors.accent,
                      size: 26,
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.product.dimensions} ${l10n.cm}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.semiBold16(context),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(
                      alpha: isDark ? 0.35 : 0.08,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.isWholesale ? l10n.wholesaleTab : l10n.retailTab,
                    style: AppStyles.regular12(context).copyWith(fontSize: 11),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.totalPrice.toInt()} ${l10n.egp}',
                  style: AppStyles.bold16Accent,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Material(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onRemove,
                  child: const Padding(
                    padding: EdgeInsets.all(7),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCountBtn(
                      context,
                      icon: Icons.remove_rounded,
                      onTap: onDecrement,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: SizedBox(
                        key: ValueKey(item.quantity),
                        width: 30,
                        child: Text(
                          '${item.quantity}',
                          textAlign: TextAlign.center,
                          style: AppStyles.semiBold16(
                            context,
                          ).copyWith(fontSize: 14),
                        ),
                      ),
                    ),
                    _buildCountBtn(
                      context,
                      icon: Icons.add_rounded,
                      onTap: onIncrement,
                      filled: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountBtn(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: filled
          ? AppColors.primary
          : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(icon, size: 16, color: filled ? Colors.white : null),
        ),
      ),
    );
  }
}