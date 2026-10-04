import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/data/models/mirror_ui_model.dart';
import 'components/mirror_card_details_footer.dart';
import 'components/mirror_card_image_header.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
              child: MirrorCardImageHeader(
                mirror: mirror,
                onPreview: onPreview,
              ),
            ),
            Expanded(
              flex: 4,
              child: MirrorCardDetailsFooter(
                mirror: mirror,
                onAddToCart: onAddToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}