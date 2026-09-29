import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class CheckoutDepositSection extends StatelessWidget {
  final String storeWalletNumber;
  final TextEditingController senderWalletController;
  final TextEditingController depositController;
  final double minDeposit;
  final double total;
  final ValueChanged<String>? onDepositChanged;

  const CheckoutDepositSection({
    super.key,
    required this.storeWalletNumber,
    required this.senderWalletController,
    required this.depositController,
    required this.minDeposit,
    required this.total,
    this.onDepositChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(l10n.depositTitle, style: AppStyles.semiBold16(context)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.phone_android_rounded,
                  color: AppColors.accent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.storeWalletLabel,
                        style: AppStyles.regular12(context),
                      ),
                      Text(
                        storeWalletNumber,
                        style: AppStyles.bold18(
                          context,
                        ).copyWith(color: AppColors.accent, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  tooltip: l10n.copyTooltip,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: storeWalletNumber));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.copiedSuccessfully),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: senderWalletController,
            label: l10n.senderWalletLabel,
            icon: Icons.send_rounded,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (v) => v == null || v.trim().isEmpty
                ? l10n.senderWalletValidation
                : null,
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: depositController,
            label: l10n.depositAmountLabel(minDeposit.toInt(), l10n.egp),
            icon: Icons.price_check_rounded,
            suffixText: l10n.egp,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onDepositChanged,
            validator: (v) {
              final parsed = double.tryParse(v ?? '') ?? 0.0;
              if (parsed < minDeposit) {
                return l10n.minDepositError(minDeposit.toInt(), l10n.egp);
              }
              if (parsed > total) {
                return l10n.maxDepositError(total.toInt(), l10n.egp);
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
