import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../data/models/mirror_ui_model.dart';
import 'components/wholesale_card_footer.dart';
import 'components/wholesale_card_header.dart';
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
          WholesaleCardHeader(
            mirror: widget.mirror,
            heroTag: heroTag,
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
          WholesaleCardFooter(
            totalPrice: _totalPrice,
            onAddToCart: () => widget.onAddToCart(_selectedTier, _totalPrice),
          ),
        ],
      ),
    );
  }
}