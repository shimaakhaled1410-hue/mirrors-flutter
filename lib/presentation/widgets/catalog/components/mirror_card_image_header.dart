import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
// import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/data/models/mirror_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'zoomable_image_dialog.dart';

class MirrorCardImageHeader extends StatelessWidget {
  final MirrorUiModel mirror;
  final VoidCallback onPreview;

  const MirrorCardImageHeader({
    super.key,
    required this.mirror,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final heroTag = 'mirror_zoom_${mirror.id}';

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: isDark ? const Color(0xFF1E1724) : const Color(0xFFFAF9FB),
          ),
        ),
        Center(
          child: mirror.imagePlaceholder != null
              ? GestureDetector(
                  onTap: () => ZoomableImageDialog.show(
                    context,
                    imagePath: mirror.imagePlaceholder!,
                    heroTag: heroTag,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 28,
                      bottom: 8,
                      left: 12,
                      right: 12,
                    ),
                    child: Hero(
                      tag: heroTag,
                      child: Image.asset(
                        mirror.imagePlaceholder!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withValues(alpha: 0.08),
                  ),
                  child: Icon(
                    mirror.subCategory == RetailSubCategory.withShelf
                        ? Icons.shelves
                        : Icons.layers_rounded,
                    size: 32,
                    color: AppColors.accent,
                  ),
                ),
        ),
        if (mirror.isRetailOnly)
          PositionedDirectional(
            top: 8,
            start: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.accent.withValues(alpha: 0.22)
                    : AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  width: 0.8,
                ),
              ),
              child: Text(
                mirror.subCategory == RetailSubCategory.withShelf
                    ? l10n.filterWithShelf
                    : l10n.filterSpecialSizes,
                style: AppStyles.regular12(context).copyWith(
                  color: AppColors.accent,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),

        // PositionedDirectional(
        //   top: 8,
        //   end: 8,
        //   child: PressableScale(
        //     child: Container(
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: surface.withValues(alpha: 0.85),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.black.withValues(alpha: 0.1),
        //             blurRadius: 8,
        //             offset: const Offset(0, 2),
        //           ),
        //         ],
        //       ),
        //       child: Material(
        //         type: MaterialType.transparency,
        //         child: InkWell(
        //           customBorder: const CircleBorder(),
        //           onTap: onPreview,
        //           child: const Padding(
        //             padding: EdgeInsets.all(7),
        //             child: Icon(
        //               Icons.view_in_ar_rounded,
        //               color: AppColors.accent,
        //               size: 17,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
