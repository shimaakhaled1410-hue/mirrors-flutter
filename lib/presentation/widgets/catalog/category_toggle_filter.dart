import 'package:flutter/material.dart';
import 'package:mirrors_app/data/models/mirror_ui_model.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class CategoryToggleFilter extends StatelessWidget {
  final MirrorCategory selectedCategory;
  final ValueChanged<MirrorCategory> onCategoryChanged;
  final String framedLabel;
  final String adhesiveLabel;

  const CategoryToggleFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.framedLabel,
    required this.adhesiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildButton(
              context,
              title: framedLabel,
              isSelected: selectedCategory == MirrorCategory.framed,
              icon: Icons.crop_portrait_rounded,
              onTap: () => onCategoryChanged(MirrorCategory.framed),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _buildButton(
              context,
              title: adhesiveLabel,
              isSelected: selectedCategory == MirrorCategory.adhesive,
              icon: Icons.layers_rounded,
              onTap: () => onCategoryChanged(MirrorCategory.adhesive),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.accent,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: isSelected
                  ? AppStyles.semiBold16(
                      context,
                    ).copyWith(color: Colors.white, fontSize: 13)
                  : AppStyles.medium14(context).copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
