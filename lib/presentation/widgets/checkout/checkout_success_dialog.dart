import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../l10n/app_localizations.dart';

class CheckoutSuccessDialog extends StatelessWidget {
  const CheckoutSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.accent,
              size: 44,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.orderPlacedSuccess,
            textAlign: TextAlign.center,
            style: AppStyles.bold18(context),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.orderPlacedSub,
            textAlign: TextAlign.center,
            style: AppStyles.regular12(context),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                context.pop();
                context.go(AppRoutes.mainLayout);
              },
              child: Text(
                l10n.goToOrders,
                style: AppStyles.semiBold16(
                  context,
                ).copyWith(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
