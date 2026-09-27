import 'package:flutter/material.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class OrderProgressStepper extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderProgressStepper({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final steps = [
      {'title': l10n.orderReceived, 'icon': Icons.receipt_long_rounded},
      {'title': l10n.orderPreparing, 'icon': Icons.inventory_rounded},
      {'title': l10n.orderShipping, 'icon': Icons.local_shipping_rounded},
      {'title': l10n.orderDelivered, 'icon': Icons.check_circle_rounded},
    ];

    return Row(
      children: List.generate(steps.length, (index) {
        final isCompleted = currentStatus.step >= index;
        final isCurrent = currentStatus.step == index;
        final step = steps[index];

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: index == 0
                        ? const SizedBox.shrink()
                        : Container(
                            height: 2,
                            color: currentStatus.step >= index
                                ? AppColors.accent
                                : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                          ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? (isCurrent ? AppColors.accent : AppColors.primary)
                          : (isDark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground),
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.accent
                            : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      step['icon'] as IconData,
                      size: 16,
                      color: isCompleted
                          ? Colors.white
                          : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                    ),
                  ),
                  Expanded(
                    child: index == steps.length - 1
                        ? const SizedBox.shrink()
                        : Container(
                            height: 2,
                            color: currentStatus.step > index
                                ? AppColors.accent
                                : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                step['title'] as String,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isCurrent
                    ? AppStyles.semiBold16(
                        context,
                      ).copyWith(fontSize: 10, color: AppColors.accent)
                    : AppStyles.regular12(context).copyWith(fontSize: 10),
              ),
            ],
          ),
        );
      }),
    );
  }
}
