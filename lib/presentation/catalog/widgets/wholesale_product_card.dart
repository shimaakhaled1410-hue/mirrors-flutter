import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../data/models/mirror_ui_model.dart';
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

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Dimensions & Base wholesale piece price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.mirror.category == MirrorCategory.framed
                          ? Icons.crop_portrait_rounded
                          : Icons.layers_rounded,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.mirror.dimensions} ${l10n.cm}',
                        style: AppStyles.semiBold16(context),
                      ),
                      Text(
                        widget.mirror.category == MirrorCategory.framed
                            ? l10n.framedMirrors
                            : l10n.adhesiveMirrors,
                        style: AppStyles.regular12(context),
                      ),
                    ],
                  ),
                ],
              ),
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
          const SizedBox(height: 12),
          // Middle: Tier Selector
          WholesaleTierSelector(
            selectedTier: _selectedTier,
            onTierSelected: (tier) {
              setState(() {
                _selectedTier = tier;
              });
            },
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Bottom Row: Total Calculations & Add to Cart button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.totalPrice, style: AppStyles.regular12(context)),
                  Text(
                    '${_totalPrice.toInt()} ${l10n.egp}',
                    style: AppStyles.bold18(
                      context,
                    ).copyWith(color: AppColors.accent),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                label: Text(
                  l10n.addToCart,
                  style: AppStyles.semiBold16(
                    context,
                  ).copyWith(color: Colors.white, fontSize: 13),
                ),
                onPressed: () => widget.onAddToCart(_selectedTier, _totalPrice),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
