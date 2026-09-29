import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import 'animated_widgets.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeSlideIn(
              index: 0,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeSlideIn(
              index: 1,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppStyles.bold18(context),
              ),
            ),
            const SizedBox(height: 10),
            FadeSlideIn(
              index: 2,
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppStyles.regular14(context).copyWith(
                  color: secondary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 28),
            FadeSlideIn(
              index: 3,
              child: PressableScale(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    elevation: 0,
                  ),
                  onPressed: onButtonPressed,
                  child: Text(
                    buttonText,
                    style: AppStyles.semiBold16(context).copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}