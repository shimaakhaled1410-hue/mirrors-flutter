import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/data/models/mirror_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

class MirrorCardDetailsFooter extends StatelessWidget {
  final MirrorUiModel mirror;
  final VoidCallback onAddToCart;

  const MirrorCardDetailsFooter({
    super.key,
    required this.mirror,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final title = mirror.subCategory == RetailSubCategory.withShelf
        ? l10n.mirrorWithShelf
        : (mirror.category == MirrorCategory.framed
            ? l10n.framedMirrors
            : l10n.adhesiveMirrors);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Column(
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
              Icon(Icons.straighten_rounded, size: 13, color: secondary),
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
          const Spacer(),
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
                        color: AppColors.primary.withValues(alpha: 0.35),
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
    );
  }
}