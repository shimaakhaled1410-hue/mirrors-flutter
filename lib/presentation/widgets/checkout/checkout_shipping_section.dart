import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_validators.dart';
import 'package:mirrors_app/core/widgets/app_text_field.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/widgets/checkout/checkout_section_card.dart';
import 'package:mirrors_app/presentation/widgets/checkout/location_selection_sheet.dart';

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

  Future<void> _pickLocation(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await LocationSelectionSheet.show(context);

    if (result is String && result.trim().isNotEmpty) {
      addressController.value = TextEditingValue(
        text: result,
        selection: TextSelection.collapsed(offset: result.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CheckoutSectionCard(
      icon: Icons.person_pin_circle_outlined,
      title: l10n.shippingDetails,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 6),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => _pickLocation(context),
              icon: const Icon(Icons.my_location_rounded, size: 18),
              label: Text(l10n.useCurrentLocation),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accent,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          const SizedBox(height: 8),
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
