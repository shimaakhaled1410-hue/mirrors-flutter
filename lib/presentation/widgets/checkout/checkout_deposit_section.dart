import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_snack_bar.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/core/utils/app_validators.dart';
import 'package:mirrors_app/core/widgets/app_text_field.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/widgets/checkout/checkout_section_card.dart';

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

    // Whole-pound limits. Rounding the minimum UP matters: with a total like
    // 351 the 50% minimum is 175.5, and 175 would be rejected by the validator.
    final minInt = minDeposit.ceil();
    final maxInt = total.floor();

    void setAmount(int amount) {
      final text = amount.toString();
      depositController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
      onDepositChanged?.call(text);
    }

    return CheckoutSectionCard(
      icon: Icons.account_balance_wallet_outlined,
      title: l10n.depositTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WalletCard(number: storeWalletNumber),
          const SizedBox(height: 16),
          AppTextField(
            controller: senderWalletController,
            label: l10n.senderWalletLabel,
            icon: Icons.send_rounded,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return l10n.fieldRequired;
              }
              if (!AppValidators.isValidEgyptianPhone(v)) {
                return l10n.invalidPhone;
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: depositController,
            label: l10n.depositAmountLabel(minInt, l10n.egp),
            icon: Icons.price_check_rounded,
            suffixText: l10n.egp,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onDepositChanged,
            validator: (v) {
              final parsed = int.tryParse(v ?? '') ?? 0;
              if (parsed < minInt) {
                return l10n.minDepositError(minInt, l10n.egp);
              }
              if (parsed > maxInt) {
                return l10n.maxDepositError(maxInt, l10n.egp);
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          // Quick picks: language-neutral labels (50% / 100%).
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: depositController,
            builder: (context, value, _) {
              final current = int.tryParse(value.text);
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _AmountChip(
                    label: '50%',
                    amount: minInt,
                    selected: current == minInt,
                    onTap: () => setAmount(minInt),
                  ),
                  _AmountChip(
                    label: '100%',
                    amount: maxInt,
                    selected: current == maxInt && maxInt != minInt,
                    onTap: () => setAmount(maxInt),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String number;
  const _WalletCard({required this.number});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    void copy() {
      Clipboard.setData(ClipboardData(text: number));
      AppSnackBar.show(
        context,
        message: l10n.copiedSuccessfully,
        icon: Icons.copy_rounded,
        duration: const Duration(seconds: 1),
      );
    }

    return Material(
      color: AppColors.accent.withValues(alpha: 0.07),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: copy,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_android_rounded,
                  color: AppColors.accent,
                  size: 22,
                ),
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
                    const SizedBox(height: 2),
                    Text(
                      number,
                      textDirection: TextDirection.ltr,
                      style: AppStyles.bold18(context).copyWith(
                        color: AppColors.accent,
                        letterSpacing: 1.2,
                      ),
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
                onPressed: copy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  final String label;
  final int amount;
  final bool selected;
  final VoidCallback onTap;

  const _AmountChip({
    required this.label,
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return ChoiceChip(
      showCheckmark: false,
      selected: selected,
      onSelected: (_) => onTap(),
      label: Text('$label  •  $amount ${l10n.egp}'),
      labelStyle: AppStyles.semiBold12(context).copyWith(
        color: selected ? AppColors.accent : null,
      ),
      selectedColor: AppColors.accent.withValues(alpha: 0.14),
      side: BorderSide(color: selected ? AppColors.accent : border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}