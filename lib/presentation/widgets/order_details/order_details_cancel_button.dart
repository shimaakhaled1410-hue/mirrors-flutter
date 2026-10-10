import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/utils/app_snack_bar.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../data/models/order_ui_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../manager/orders/orders_cubit.dart';

class OrderDetailsCancelButton extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsCancelButton({super.key, required this.order});

  void _showCancelDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l10n.cancelOrderDialogTitle(order.orderId),
          style: AppStyles.bold16(dialogContext),
        ),
        content: Text(
          l10n.cancelOrderDialogMessage,
          style: AppStyles.regular14(dialogContext),
        ),
        actions: [
          TextButton(
            onPressed: () => dialogContext.pop(),
            child: Text(
              l10n.keepOrderButton,
              style: AppStyles.medium14(dialogContext),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              dialogContext.pop();
              context.read<OrdersCubit>().cancelOrder(order.orderId);
              AppSnackBar.show(
                context,
                message: l10n.orderCancelledSnackbar,
                icon: Icons.cancel_outlined,
              );
            },
            child: Text(
              l10n.confirmCancelButton,
              style: AppStyles.semiBold16(
                dialogContext,
              ).copyWith(fontSize: 13, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.red.shade400,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: () => _showCancelDialog(context),
        icon: const Icon(Icons.cancel_outlined, size: 16),
        label: Text(
          l10n.cancelOrder,
          style: AppStyles.regular14(
            context,
          ).copyWith(color: Colors.red.shade400, fontSize: 13),
        ),
      ),
    );
  }
}
