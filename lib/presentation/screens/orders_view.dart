import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../../../core/utils/app_styles.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.ordersTab,
        style: AppStyles.bold18(context),
      ),
    );
  }
}