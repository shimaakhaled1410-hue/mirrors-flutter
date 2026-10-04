import 'package:flutter/material.dart';
import 'package:mirrors_app/presentation/widgets/catalog/components/zoomable_image_dialog.dart';
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
            final categoryTitle = item.product.subCategory == RetailSubCategory.withShelf
                ? l10n.mirrorWithShelf
                : (item.product.category == MirrorCategory.framed
                    ? l10n.framedMirrors
                    : l10n.adhesiveMirrors);

            final heroTag = 'order_detail_zoom_${item.id}';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
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
                      width: 48,
                      height: 64,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E1724)
                            : const Color(0xFFFAF9FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border),
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
                              item.product.subCategory == RetailSubCategory.withShelf
                                  ? Icons.shelves
                                  : (item.product.category == MirrorCategory.framed
                                      ? Icons.crop_portrait_rounded
                                      : Icons.layers_rounded),
                              color: AppColors.accent,
                              size: 22,
                            ),
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
                        const SizedBox(height: 2),
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