import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../data/models/mirror_ui_model.dart';
import '../../../../l10n/app_localizations.dart';

class PreviewBottomCard extends StatelessWidget {
  final MirrorUiModel mirror;
  final VoidCallback onAddToCart;

  const PreviewBottomCard({
    super.key,
    required this.mirror,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${mirror.dimensions} ${l10n.cm}',
                    style: AppStyles.bold16Accent,
                  ),
                  Text(
                    '${mirror.retailPrice.toInt()} ${l10n.egp}',
                    style: AppStyles.medium14(context),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onPressed: onAddToCart,
              icon: const Icon(
                Icons.add_shopping_cart_rounded,
                size: 18,
              ),
              label: Text(l10n.addToCart),
            ),
          ],
        ),
      ),
    );
  }
}