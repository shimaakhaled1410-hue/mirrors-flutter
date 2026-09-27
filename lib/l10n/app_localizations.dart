import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mirrors Store'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mirrors App!'**
  String get welcomeMessage;

  /// No description provided for @retailTab.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get retailTab;

  /// No description provided for @wholesaleTab.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get wholesaleTab;

  /// No description provided for @ordersTab.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get ordersTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @framedMirrors.
  ///
  /// In en, this message translates to:
  /// **'Framed Mirrors'**
  String get framedMirrors;

  /// No description provided for @adhesiveMirrors.
  ///
  /// In en, this message translates to:
  /// **'Adhesive Mirrors'**
  String get adhesiveMirrors;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @viewInRoom.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get viewInRoom;

  /// No description provided for @selectQuantity.
  ///
  /// In en, this message translates to:
  /// **'Select Quantity'**
  String get selectQuantity;

  /// No description provided for @quarterDozen.
  ///
  /// In en, this message translates to:
  /// **'1/4 Dozen (3)'**
  String get quarterDozen;

  /// No description provided for @halfDozen.
  ///
  /// In en, this message translates to:
  /// **'1/2 Dozen (6)'**
  String get halfDozen;

  /// No description provided for @oneDozen.
  ///
  /// In en, this message translates to:
  /// **'1 Dozen (12)'**
  String get oneDozen;

  /// No description provided for @oneAndHalfDozen.
  ///
  /// In en, this message translates to:
  /// **'1.5 Dozen (18)'**
  String get oneAndHalfDozen;

  /// No description provided for @twoDozens.
  ///
  /// In en, this message translates to:
  /// **'2 Dozens (24)'**
  String get twoDozens;

  /// No description provided for @unitWholesalePrice.
  ///
  /// In en, this message translates to:
  /// **'Piece wholesale'**
  String get unitWholesalePrice;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @piecesCount.
  ///
  /// In en, this message translates to:
  /// **'pieces'**
  String get piecesCount;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get orderNumber;

  /// No description provided for @orderReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get orderReceived;

  /// No description provided for @orderPreparing.
  ///
  /// In en, this message translates to:
  /// **'Packaging'**
  String get orderPreparing;

  /// No description provided for @orderShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderShipping;

  /// No description provided for @orderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderDelivered;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @userAccount.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get userAccount;

  /// No description provided for @storeOwnerOrCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer / Store Owner'**
  String get storeOwnerOrCustomer;

  /// No description provided for @safetyAndGuide.
  ///
  /// In en, this message translates to:
  /// **'Glass Handling & Installation Guide'**
  String get safetyAndGuide;

  /// No description provided for @safetyTip1.
  ///
  /// In en, this message translates to:
  /// **'Handle with care. Unbox on a soft flat surface.'**
  String get safetyTip1;

  /// No description provided for @safetyTip2.
  ///
  /// In en, this message translates to:
  /// **'Clean wall thoroughly with alcohol before sticking adhesive mirrors.'**
  String get safetyTip2;

  /// No description provided for @safetyTip3.
  ///
  /// In en, this message translates to:
  /// **'Use sturdy wall anchors for hanging rope-framed mirrors.'**
  String get safetyTip3;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat with Store via WhatsApp'**
  String get contactSupport;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appSettings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get changeLanguage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
