import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../data/models/mirror_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

class CartItemDetails extends StatelessWidget {
  final CartItemModel item;

  const CartItemDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    final mirrorTypeTitle =
        item.product.subCategory == RetailSubCategory.withShelf
        ? l10n.mirrorWithShelf
        : (item.product.category == MirrorCategory.framed
              ? l10n.framedMirrors
              : l10n.adhesiveMirrors);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mirrorTypeTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.semiBold14(context),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              '${item.product.dimensions} ${l10n.cm}',
              style: AppStyles.regular12(
                context,
              ).copyWith(color: secondary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: item.isWholesale
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.isWholesale ? l10n.wholesaleTab : l10n.retailTab,
                style: AppStyles.regular12(context).copyWith(
                  fontSize: 10,
                  color: item.isWholesale ? AppColors.accent : null,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${item.totalPrice.toInt()} ${l10n.egp}',
          style: AppStyles.bold16Accent,
        ),
      ],
    );
  }
}
