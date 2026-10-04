import 'package:flutter/material.dart';
import 'package:mirrors_app/presentation/widgets/catalog/components/zoomable_image_dialog.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../../data/models/mirror_ui_model.dart';

class CartItemThumbnail extends StatelessWidget {
  final CartItemModel item;

  const CartItemThumbnail({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final heroTag = 'cart_mirror_zoom_${item.id}';

    return GestureDetector(
      onTap: () {
        if (item.product.imagePlaceholder != null) {
          ZoomableImageDialog.show(
            context,
            imagePath: item.product.imagePlaceholder!,
            heroTag: heroTag,
          );
        }
      },
      child: Container(
        width: 54,
        height: 72,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1724) : const Color(0xFFFAF9FB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: item.product.imagePlaceholder != null
            ? Hero(
                tag: heroTag,
                child: Image.asset(
                  item.product.imagePlaceholder!,
                  fit: BoxFit.contain,
                ),
              )
            : Icon(
                item.product.category == MirrorCategory.framed
                    ? Icons.crop_portrait_rounded
                    : Icons.layers_rounded,
                color: AppColors.accent,
                size: 26,
              ),
      ),
    );
  }
}