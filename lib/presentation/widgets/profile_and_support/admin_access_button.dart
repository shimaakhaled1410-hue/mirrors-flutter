import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../l10n/app_localizations.dart';

class AdminAccessButton extends StatelessWidget {
  const AdminAccessButton({super.key});

  static const String _defaultAdminPin = '1234';

  void _showPinDialog(BuildContext context) {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          title: Text(
            l10n.adminAccess,
            textAlign: TextAlign.center,
            style: AppStyles.bold18(context),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.adminPinPrompt,
                textAlign: TextAlign.center,
                style: AppStyles.regular12(context),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                obscureText: true,
                textAlign: TextAlign.center,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: true,
                style: const TextStyle(
                  letterSpacing: 10,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color:
                          isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (controller.text.trim() == _defaultAdminPin) {
                  dialogContext.pop();
                  context.push(AppRoutes.adminOrders);
                } else {
                  AppSnackBar.showError(
                    context,
                    message: l10n.invalidPin,
                  );
                }
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: isDark
              ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
              : AppColors.lightTextSecondary.withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: () => _showPinDialog(context),
        icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
        label: Text(
          l10n.adminAccess,
          style: AppStyles.regular12(context),
        ),
      ),
    );
  }
}