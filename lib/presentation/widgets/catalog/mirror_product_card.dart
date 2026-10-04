import 'package:flutter/material.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
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
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final secondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final title = mirror.subCategory == RetailSubCategory.withShelf
        ? l10n.mirrorWithShelf
        : (mirror.category == MirrorCategory.framed
            ? l10n.framedMirrors
            : l10n.adhesiveMirrors);

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            background,
                            isDark
                                ? const Color(0xFF1A1320)
                                : const Color(0xFFF0E8EB),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: mirror.imagePlaceholder != null
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              mirror.imagePlaceholder!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent.withValues(alpha: 0.08),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.22),
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: isDark ? 0.3 : 0.08,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  mirror.subCategory == RetailSubCategory.withShelf
                                      ? Icons.shelves
                                      : (mirror.category == MirrorCategory.framed
                                          ? Icons.crop_portrait_rounded
                                          : Icons.layers_rounded),
                                  size: 28,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ),
                  ),
                  if (mirror.isRetailOnly)
                    PositionedDirectional(
                      top: 10,
                      start: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          mirror.subCategory == RetailSubCategory.withShelf
                              ? l10n.filterWithShelf
                              : l10n.filterSpecialSizes,
                          style: AppStyles.regular12(context).copyWith(
                            color: AppColors.accent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  PositionedDirectional(
                    top: 8,
                    end: 8,
                    child: PressableScale(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: surface.withValues(alpha: 0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onPreview,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.view_in_ar_rounded,
                                color: AppColors.accent,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.semiBold14(context),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.straighten_rounded,
                              size: 13,
                              color: secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${mirror.dimensions} ${l10n.cm}',
                              style: AppStyles.regular12(context).copyWith(
                                color: secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${mirror.retailPrice.toInt()} ${l10n.egp}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.bold16Accent,
                          ),
                        ),
                        const SizedBox(width: 6),
                        PressableScale(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.35,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: onAddToCart,
                                child: const Padding(
                                  padding: EdgeInsets.all(9),
                                  child: Icon(
                                    Icons.add_shopping_cart_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}