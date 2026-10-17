import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

class PickerAddressCard extends StatelessWidget {
  final ValueListenable<bool> busy;
  final ValueListenable<String?> address;
  final Color surface;
  final ValueChanged<String> onConfirm;

  const PickerAddressCard({
    super.key,
    required this.busy,
    required this.address,
    required this.surface,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: surface,
      elevation: 6,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListenableBuilder(
          listenable: Listenable.merge([busy, address]),
          builder: (context, _) {
            final isBusy = busy.value;
            final current = address.value;
            final confirmable = !isBusy && current != null;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isBusy || current == null
                            ? l10n.fetchingAddress
                            : current,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: isBusy
                            ? AppStyles.regular14(context)
                            : AppStyles.semiBold14(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: confirmable ? () => onConfirm(current) : null,
                    icon: const Icon(Icons.check_rounded, size: 20),
                    label: Text(l10n.confirmLocation),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}