import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../data/models/order_ui_model.dart';
import '../../../l10n/app_localizations.dart';

class AdminOrderCard extends StatelessWidget {
  final OrderUiModel order;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onChangeStatus;

  const AdminOrderCard({
    super.key,
    required this.order,
    required this.onCall,
    required this.onWhatsApp,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '#${order.orderId}',
                  style: AppStyles.bold16(context),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status.localizedName(l10n),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                if (order.phoneNumber != null &&
                    order.phoneNumber!.isNotEmpty) ...[
                  IconButton.filledTonal(
                    onPressed: onCall,
                    icon: const Icon(Icons.phone_rounded, size: 16),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    onPressed: onWhatsApp,
                    icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${order.customerName ?? '-'} • ${order.phoneNumber ?? '-'}',
              style: AppStyles.semiBold14(context),
            ),
            if (order.address != null && order.address!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                order.address!,
                style: AppStyles.regular12(context),
              ),
            ],
            if (order.senderWalletNumber != null &&
                order.senderWalletNumber!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '${l10n.senderWalletLabel}: ${order.senderWalletNumber}',
                style: AppStyles.regular12(context).copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
            if (order.items.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Text(
                l10n.itemsSummary,
                style: AppStyles.semiBold12(context),
              ),
              const SizedBox(height: 6),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 6,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${item.product.dimensions} ${l10n.cm} × ${item.quantity}',
                          style: AppStyles.regular12(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${item.totalPrice.toInt()} ${l10n.egp}',
                        style: AppStyles.semiBold12(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.depositPaidLabel,
                          style: AppStyles.regular12(context),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${order.depositAmount.toInt()} ${l10n.egp}',
                          style: AppStyles.bold14(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.remainingToPay,
                          style: AppStyles.regular12(context),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${order.remainingAmount.toInt()} ${l10n.egp}',
                          style: AppStyles.bold14(context).copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onChangeStatus,
                icon: const Icon(Icons.edit_note_rounded, size: 18),
                label: Text(l10n.changeStatus),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}