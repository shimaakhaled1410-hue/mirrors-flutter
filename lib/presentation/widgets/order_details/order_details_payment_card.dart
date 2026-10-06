import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../data/models/order_ui_model.dart';
import '../../../l10n/app_localizations.dart';
import 'order_details_info_row.dart';

class OrderDetailsPaymentCard extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsPaymentCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.depositAndPaymentDetails,
                style: AppStyles.semiBold16(context),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OrderDetailsInfoRow(
            label: l10n.paymentMethod,
            value: order.paymentMethod ?? l10n.vodafoneCash,
          ),
          if (order.senderWalletNumber != null &&
              order.senderWalletNumber!.isNotEmpty) ...[
            const Divider(height: 16),
            OrderDetailsInfoRow(
              label: l10n.senderWalletLabel,
              value: order.senderWalletNumber!,
            ),
          ],
        ],
      ),
    );
  }
}