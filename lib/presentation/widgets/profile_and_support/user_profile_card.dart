import 'package:flutter/material.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: 0.12),
              border: Border.all(color: AppColors.accent, width: 2),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: AppColors.accent,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.userAccount, style: AppStyles.semiBold16(context)),
                const SizedBox(height: 4),
                Text(
                  l10n.storeOwnerOrCustomer,
                  style: AppStyles.regular12(context),
                ),
              ],
            ),
          ),
          PressableScale(
            child: Material(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              shape: CircleBorder(side: BorderSide(color: border)),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  // TODO: Edit profile info
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.edit_outlined, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}