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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SizedBox(
        height: 46,
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              alignment: selectedCategory == MirrorCategory.framed
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
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
          ],
        ),
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
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<Color?>(
                tween: ColorTween(
                  end: isSelected ? Colors.white : AppColors.accent,
                ),
                duration: const Duration(milliseconds: 280),
                builder: (context, color, _) =>
                    Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 280),
                  style: isSelected
                      ? AppStyles.semiBold16(
                          context,
                        ).copyWith(color: Colors.white, fontSize: 13)
                      : AppStyles.medium14(context).copyWith(fontSize: 13),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}