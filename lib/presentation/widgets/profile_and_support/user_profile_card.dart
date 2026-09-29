import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_storage_keys.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/animated_widgets.dart';
import '../../../../l10n/app_localizations.dart';
import 'edit_profile_bottom_sheet.dart';

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  String? _name;
  String? _phone;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString(AppStorageKeys.customerName);
      _phone = prefs.getString(AppStorageKeys.customerPhone);
    });
  }

  void _openEditProfileSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => EditProfileBottomSheet(
        onSaved: _loadProfileData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final displayName = (_name != null && _name!.trim().isNotEmpty)
        ? _name!
        : l10n.userAccount;

    final displaySubtitle = (_phone != null && _phone!.trim().isNotEmpty)
        ? _phone!
        : l10n.storeOwnerOrCustomer;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withValues(alpha: 0.12),
              border: Border.all(color: AppColors.accent, width: 2),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: AppColors.accent,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName, style: AppStyles.semiBold16(context)),
                const SizedBox(height: 4),
                Text(
                  displaySubtitle,
                  style: AppStyles.regular12(context),
                ),
              ],
            ),
          ),
          PressableScale(
            child: Material(
              color: isDark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
              shape: CircleBorder(side: BorderSide(color: border)),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _openEditProfileSheet(context),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.edit_outlined, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}