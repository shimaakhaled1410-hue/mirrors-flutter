import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_styles.dart';

class WholesaleView extends StatelessWidget {
  const WholesaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.wholesaleTab,
        style: AppStyles.bold18(context),
      ),
    );
  }
}