import 'package:flutter/material.dart';
import 'package:mirrors_app/data/models/mirror_ui_model.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import 'zoomable_image_dialog.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

class WholesaleCardHeader extends StatelessWidget {
  final MirrorUiModel mirror;
  final String heroTag;

  const WholesaleCardHeader({
    super.key,
    required this.mirror,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (mirror.imagePlaceholder != null) {
                    ZoomableImageDialog.show(
                      context,
                      imagePath: mirror.imagePlaceholder!,
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
                  child: mirror.imagePlaceholder != null
                      ? Hero(
                          tag: heroTag,
                          child: Image.asset(
                            mirror.imagePlaceholder!,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Icon(
                          mirror.category == MirrorCategory.framed
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
                      '${mirror.dimensions} ${l10n.cm}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.semiBold16(context),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mirror.category == MirrorCategory.framed
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
              '${mirror.wholesalePrice.toInt()} ${l10n.egp}',
              style: AppStyles.bold16Accent,
            ),
            Text(
              l10n.unitWholesalePrice,
              style: AppStyles.regular12(context),
            ),
          ],
        ),
      ],
    );
  }
}