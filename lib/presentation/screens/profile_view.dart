import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_styles.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.profileTab,
        style: AppStyles.bold18(context),
      ),
    );
  }
}