// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mirrors Store';

  @override
  String get welcomeMessage => 'Welcome to Mirrors App!';

  @override
  String get retailTab => 'Retail';

  @override
  String get wholesaleTab => 'Wholesale';

  @override
  String get ordersTab => 'My Orders';

  @override
  String get profileTab => 'Profile';
}
