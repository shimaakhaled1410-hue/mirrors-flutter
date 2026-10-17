import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/widgets/checkout/checkout_submit_button.dart';

/// Always-visible bar with the order total and the confirm button.
class CheckoutBottomBar extends StatelessWidget {
  final double total;
  final bool isLoading;
  final VoidCallback onPressed;

  const CheckoutBottomBar({
    super.key,
    required this.total,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.total, style: AppStyles.regular12(context)),
                  Text(
                    '${total.toInt()} ${l10n.egp}',
                    style: AppStyles.bold18(context),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CheckoutSubmitButton(
                  onPressed: onPressed,
                  label: l10n.placeOrder,
                  isLoading: isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}