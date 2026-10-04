import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../data/models/cart_item_model.dart';
import 'components/cart_item_actions.dart';
import 'components/cart_item_details.dart';
import 'components/cart_item_thumbnail.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CartItemThumbnail(item: item),
          const SizedBox(width: 14),
          Expanded(child: CartItemDetails(item: item)),
          CartItemActions(
            quantity: item.quantity,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            onRemove: onRemove,
          ),
        ],
      ),
    );
  }
}