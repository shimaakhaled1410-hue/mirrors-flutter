// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'متجر المرايات';

  @override
  String get welcomeMessage => 'مرحباً بك في تطبيق المرايات!';

  @override
  String get retailTab => 'قطاعي';

  @override
  String get wholesaleTab => 'جملة';

  @override
  String get ordersTab => 'طلباتي';

  @override
  String get profileTab => 'حسابي';

  @override
  String get framedMirrors => 'مرايات بإطار';

  @override
  String get adhesiveMirrors => 'مرايات لصق دبل';

  @override
  String get addToCart => 'إضافة للسلة';

  @override
  String get cm => 'سم';

  @override
  String get egp => 'ج.م';

  @override
  String get viewInRoom => 'معاينة';
}
