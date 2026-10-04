import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class CartItemActions extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemActions({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Material(
          color: AppColors.error.withValues(alpha: 0.1),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.all(7),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: AppColors.error,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkBackground
                : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCountBtn(
                context,
                icon: Icons.remove_rounded,
                onTap: onDecrement,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: SizedBox(
                  key: ValueKey(quantity),
                  width: 32,
                  child: Text(
                    '$quantity',
                    textAlign: TextAlign.center,
                    style: AppStyles.semiBold16(context).copyWith(fontSize: 13),
                  ),
                ),
              ),
              _buildCountBtn(
                context,
                icon: Icons.add_rounded,
                onTap: onIncrement,
                filled: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCountBtn(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: filled
          ? AppColors.primary
          : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(icon, size: 16, color: filled ? Colors.white : null),
        ),
      ),
    );
  }
}
