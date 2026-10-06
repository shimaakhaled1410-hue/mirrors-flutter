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
    final idleColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final doneColor = isDark ? AppColors.primaryLight : AppColors.primary;

    final steps = [
      {'title': l10n.orderReceived, 'icon': Icons.receipt_long_rounded},
      {'title': l10n.statusDepositConfirmed, 'icon': Icons.price_check_rounded},
      {'title': l10n.orderPreparing, 'icon': Icons.inventory_rounded},
      {'title': l10n.orderShipping, 'icon': Icons.local_shipping_rounded},
      {'title': l10n.orderDelivered, 'icon': Icons.check_circle_rounded},
    ];

    Widget line(bool active) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          height: 3,
          decoration: BoxDecoration(
            color: active ? AppColors.accent : idleColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
    }

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
                        : line(currentStatus.step >= index),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? (isCurrent ? AppColors.accent : doneColor)
                          : (isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground),
                      border: Border.all(
                        color: isCompleted ? AppColors.accent : idleColor,
                        width: 1.5,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.45),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ]
                          : const [],
                    ),
                    child: Icon(
                      step['icon'] as IconData,
                      size: 14,
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
                        : line(currentStatus.step > index),
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
                    ? AppStyles.semiBold16(context)
                        .copyWith(fontSize: 9, color: AppColors.accent)
                    : AppStyles.regular12(context).copyWith(fontSize: 9),
              ),
            ],
          ),
        );
      }),
    );
  }
}