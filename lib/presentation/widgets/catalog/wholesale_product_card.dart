import 'package:flutter/material.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../data/models/mirror_ui_model.dart';
import 'components/zoomable_image_dialog.dart';
import 'wholesale_tier_selector.dart';

class WholesaleProductCard extends StatefulWidget {
  final MirrorUiModel mirror;
  final Function(WholesaleTier tier, double totalPrice) onAddToCart;

  const WholesaleProductCard({
    super.key,
    required this.mirror,
    required this.onAddToCart,
  });

  @override
  State<WholesaleProductCard> createState() => _WholesaleProductCardState();
}

class _WholesaleProductCardState extends State<WholesaleProductCard> {
  WholesaleTier _selectedTier = WholesaleTier.oneDozen;

  double get _totalPrice =>
      widget.mirror.wholesalePrice * _selectedTier.quantity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final heroTag = 'wholesale_mirror_zoom_${widget.mirror.id}';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.mirror.imagePlaceholder != null) {
                          ZoomableImageDialog.show(
                            context,
                            imagePath: widget.mirror.imagePlaceholder!,
                            heroTag: heroTag,
                          );
                        }
                      },
                      child: Container(
                        width: 54,
                        height: 70,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E1724)
                              : const Color(0xFFFAF9FB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: widget.mirror.imagePlaceholder != null
                            ? Hero(
                                tag: heroTag,
                                child: Image.asset(
                                  widget.mirror.imagePlaceholder!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Icon(
                                widget.mirror.category == MirrorCategory.framed
                                    ? Icons.crop_portrait_rounded
                                    : Icons.layers_rounded,
                                color: AppColors.accent,
                                size: 24,
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.mirror.dimensions} ${l10n.cm}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.semiBold16(context),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.mirror.category == MirrorCategory.framed
                                ? l10n.framedMirrors
                                : l10n.adhesiveMirrors,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.regular12(context).copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.mirror.wholesalePrice.toInt()} ${l10n.egp}',
                    style: AppStyles.bold16Accent,
                  ),
                  Text(
                    l10n.unitWholesalePrice,
                    style: AppStyles.regular12(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          WholesaleTierSelector(
            selectedTier: _selectedTier,
            onTierSelected: (tier) {
              setState(() {
                _selectedTier = tier;
              });
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.totalPrice,
                        style: AppStyles.regular12(context),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        switchInCurve: Curves.easeOutCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          '${_totalPrice.toInt()} ${l10n.egp}',
                          key: ValueKey(_totalPrice.toInt()),
                          style: AppStyles.bold18(
                            context,
                          ).copyWith(color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
                PressableScale(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () =>
                            widget.onAddToCart(_selectedTier, _totalPrice),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 11,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.addToCart,
                                style: AppStyles.semiBold16(
                                  context,
                                ).copyWith(color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}