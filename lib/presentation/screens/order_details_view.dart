import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/data/models/mirror_ui_model.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/widgets/orders/order_progress_stepper.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderUiModel order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final secondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.orderNumber}${order.orderId}'),
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Order Status & Stepper Card
          FadeSlideIn(
            index: 0,
            child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'مرحلة التنفيذ والتوصيل',
                        style: AppStyles.semiBold16(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: border),
                        ),
                        child: Text(
                          order.date,
                          style: AppStyles.regular12(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 4),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                    ),
                    child: OrderProgressStepper(currentStatus: order.status),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Shipping & Contact Details
          FadeSlideIn(
            index: 1,
            child: Container(
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
                      const Icon(Icons.person_outline,
                          color: AppColors.accent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.shippingDetails,
                        style: AppStyles.semiBold16(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildInfoRow(
                    context,
                    label: l10n.fullName,
                    value: order.customerName?.isNotEmpty == true
                        ? order.customerName!
                        : 'غير مسجل',
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    context,
                    label: 'هاتف التواصل',
                    value: order.phoneNumber?.isNotEmpty == true
                        ? order.phoneNumber!
                        : 'غير مسجل',
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    context,
                    label: l10n.address,
                    value: order.address?.isNotEmpty == true
                        ? order.address!
                        : 'غير مسجل',
                  ),
                  if (order.notes != null && order.notes!.isNotEmpty) ...[
                    const Divider(height: 16),
                    _buildInfoRow(
                      context,
                      label: 'ملاحظات',
                      value: order.notes!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Deposit & Payment Info
          FadeSlideIn(
            index: 2,
            child: Container(
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
                      const Icon(Icons.account_balance_wallet_outlined,
                          color: AppColors.accent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'بيانات السداد والعربون',
                        style: AppStyles.semiBold16(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildInfoRow(
                    context,
                    label: 'طريقة الدفع',
                    value: order.paymentMethod ?? 'فودافون كاش (عربون)',
                  ),
                  if (order.senderWalletNumber != null &&
                      order.senderWalletNumber!.isNotEmpty) ...[
                    const Divider(height: 16),
                    _buildInfoRow(
                      context,
                      label: 'المحفظة المحول منها',
                      value: order.senderWalletNumber!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4. Purchased Items List
          if (order.items.isNotEmpty) ...[
            FadeSlideIn(
              index: 3,
              child: Container(
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
                        const Icon(Icons.inventory_2_outlined,
                            color: AppColors.accent, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'المنتجات (${order.totalItems})',
                          style: AppStyles.semiBold16(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...order.items.map((item) {
                      final isFramed =
                          item.product.category == MirrorCategory.framed;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.crop_portrait_rounded,
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
                                    'مرآة مقاس ${item.product.dimensions} سم',
                                    style: AppStyles.semiBold16(context)
                                        .copyWith(fontSize: 14),
                                  ),
                                  Text(
                                    '${isFramed ? "بإطار كلاسيكي" : "لصق وجهين"} • الكمية: ${item.quantity}',
                                    style: AppStyles.regular12(context)
                                        .copyWith(color: secondary),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${item.totalPrice.toInt()} ${l10n.egp}',
                              style: AppStyles.bold16(context)
                                  .copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 5. Total Financial Summary
          FadeSlideIn(
            index: 4,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.total, style: AppStyles.semiBold16(context)),
                      Text(
                        '${order.totalPrice.toInt()} ${l10n.egp}',
                        style: AppStyles.bold16(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('العربون المدفوع:',
                          style: AppStyles.regular14(context)),
                      Text(
                        '${order.depositAmount.toInt()} ${l10n.egp}',
                        style: AppStyles.bold16Accent,
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المتبقي للمندوب عند الاستلام:',
                        style: AppStyles.semiBold16(context)
                            .copyWith(color: Colors.green),
                      ),
                      Text(
                        '${order.remainingAmount.toInt()} ${l10n.egp}',
                        style: AppStyles.bold18(context)
                            .copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final secondary = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.regular14(context).copyWith(color: secondary),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppStyles.medium14(context),
          ),
        ),
      ],
    );
  }
}