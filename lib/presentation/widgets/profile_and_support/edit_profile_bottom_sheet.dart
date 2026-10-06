import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/utils/app_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_storage_keys.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class EditProfileBottomSheet extends StatefulWidget {
  final VoidCallback onSaved;

  const EditProfileBottomSheet({super.key, required this.onSaved});

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString(AppStorageKeys.customerName) ?? '';
      _phoneController.text =
          prefs.getString(AppStorageKeys.customerPhone) ?? '';
      _addressController.text =
          prefs.getString(AppStorageKeys.customerAddress) ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppStorageKeys.customerName,
      _nameController.text.trim(),
    );
    await prefs.setString(
      AppStorageKeys.customerPhone,
      _phoneController.text.trim(),
    );
    await prefs.setString(
      AppStorageKeys.customerAddress,
      _addressController.text.trim(),
    );

    widget.onSaved();

    if (!mounted) return;
    context.pop();

    final l10n = AppLocalizations.of(context)!;
    AppSnackBar.showSuccess(context, message: l10n.infoSavedSuccess);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(l10n.editProfileTitle, style: AppStyles.semiBold16(context)),
          const SizedBox(height: 18),
          AppTextField(
            controller: _nameController,
            label: l10n.fullName,
            icon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: _phoneController,
            label: l10n.courierContactPhone,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.telephoneNumber],
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: _addressController,
            label: l10n.address,
            icon: Icons.location_on_outlined,
            maxLines: 2,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            autofillHints: const [AutofillHints.fullStreetAddress],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _saveData,
              child: Text(
                l10n.saveChanges,
                style: AppStyles.semiBold16(
                  context,
                ).copyWith(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
