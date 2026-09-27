import 'package:flutter/material.dart';
import 'package:mirrors_app/data/models/mirror_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class MirrorProductCard extends StatelessWidget {
  final MirrorUiModel mirror;
  final VoidCallback onAddToCart;
  final VoidCallback onPreview;

  const MirrorProductCard({
    super.key,
    required this.mirror,
    required this.onAddToCart,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image / Visual Area with Quick Actions
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      mirror.category == MirrorCategory.framed
                          ? Icons.crop_portrait_rounded
                          : Icons.layers_rounded,
                      size: 54,
                      color: isDark
                          ? AppColors.darkTextSecondary.withValues(alpha: 0.4)
                          : AppColors.lightTextSecondary.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                // Dimension Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${mirror.dimensions} ${l10n.cm}',
                      style: AppStyles.regular12(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Camera Preview Icon Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: IconButton.filledTonal(
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.darkSurface.withValues(alpha: 0.8)
                          : AppColors.lightSurface.withValues(alpha: 0.9),
                    ),
                    icon: const Icon(
                      Icons.view_in_ar_rounded,
                      color: AppColors.accent,
                      size: 18,
                    ),
                    onPressed: onPreview,
                  ),
                ),
              ],
            ),
          ),

          // Details & Price Area
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    mirror.category == MirrorCategory.framed
                        ? l10n.framedMirrors
                        : l10n.adhesiveMirrors,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.medium14(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${mirror.retailPrice.toInt()} ${l10n.egp}',
                        style: AppStyles.bold16Accent,
                      ),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: onAddToCart,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
