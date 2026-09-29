import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class CheckoutShippingSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController notesController;

  const CheckoutShippingSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

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
                Icons.person_pin_circle_outlined,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(l10n.shippingDetails, style: AppStyles.semiBold16(context)),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: nameController,
            label: l10n.fullName,
            icon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            validator: (v) =>
                v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: phoneController,
            label: l10n.courierContactPhone,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.telephoneNumber],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.fieldRequired;
              if (v.trim().length < 10) return l10n.invalidPhone;
              return null;
            },
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: addressController,
            label: l10n.address,
            icon: Icons.location_on_outlined,
            maxLines: 2,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            autofillHints: const [AutofillHints.fullStreetAddress],
            validator: (v) =>
                v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: notesController,
            label: l10n.notesOptional,
            icon: Icons.note_alt_outlined,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
