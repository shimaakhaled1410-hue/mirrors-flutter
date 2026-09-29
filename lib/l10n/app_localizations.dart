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
  /// **'Contact Support'**
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

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get cartTitle;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @shippingFee.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shippingFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get checkout;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cashOnDelivery;

  /// No description provided for @vodafoneCash.
  ///
  /// In en, this message translates to:
  /// **'Vodafone Cash'**
  String get vodafoneCash;

  /// No description provided for @visaCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get visaCard;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @shippingDetails.
  ///
  /// In en, this message translates to:
  /// **'Shipping Details'**
  String get shippingDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get address;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Delivery Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Place Order'**
  String get placeOrder;

  /// No description provided for @orderPlacedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your order has been placed successfully!'**
  String get orderPlacedSuccess;

  /// No description provided for @goToOrders.
  ///
  /// In en, this message translates to:
  /// **'Track My Order'**
  String get goToOrders;

  /// No description provided for @depositTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Deposit (Vodafone Cash)'**
  String get depositTitle;

  /// No description provided for @storeWalletLabel.
  ///
  /// In en, this message translates to:
  /// **'Store wallet number for transfer:'**
  String get storeWalletLabel;

  /// No description provided for @copiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Wallet number copied successfully'**
  String get copiedSuccessfully;

  /// No description provided for @copyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy number'**
  String get copyTooltip;

  /// No description provided for @senderWalletLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet number transferred from'**
  String get senderWalletLabel;

  /// No description provided for @senderWalletValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter the transfer wallet number'**
  String get senderWalletValidation;

  /// No description provided for @depositAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Deposit amount (Min 50% = {amount} {currency})'**
  String depositAmountLabel(int amount, String currency);

  /// No description provided for @minDepositError.
  ///
  /// In en, this message translates to:
  /// **'Deposit cannot be less than 50% ({amount} {currency})'**
  String minDepositError(int amount, String currency);

  /// No description provided for @maxDepositError.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot exceed total ({amount} {currency})'**
  String maxDepositError(int amount, String currency);

  /// No description provided for @depositPaidNow.
  ///
  /// In en, this message translates to:
  /// **'Deposit paid now:'**
  String get depositPaidNow;

  /// No description provided for @remainingOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Remaining upon delivery:'**
  String get remainingOnDelivery;

  /// No description provided for @confirmOrderButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order & Submit Deposit'**
  String get confirmOrderButton;

  /// No description provided for @orderPlacedSub.
  ///
  /// In en, this message translates to:
  /// **'The store will verify your deposit transfer and begin preparing your mirrors immediately.'**
  String get orderPlacedSub;

  /// No description provided for @courierContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Courier contact phone number'**
  String get courierContactPhone;

  /// No description provided for @orderTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Progress & Delivery'**
  String get orderTrackingTitle;

  /// No description provided for @notRegistered.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notRegistered;

  /// No description provided for @depositAndPaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment & Deposit Details'**
  String get depositAndPaymentDetails;

  /// No description provided for @itemsCountTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchased items ({count})'**
  String itemsCountTitle(int count);

  /// No description provided for @mirrorUnitDimensions.
  ///
  /// In en, this message translates to:
  /// **'Mirror {dimensions} cm'**
  String mirrorUnitDimensions(String dimensions);

  /// No description provided for @depositPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid deposit:'**
  String get depositPaidLabel;

  /// No description provided for @deliveryNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get deliveryNotes;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @whatsappError.
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp. Please ensure it is installed on your device.'**
  String get whatsappError;

  /// No description provided for @generalSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, I would like to inquire about customized mirrors.'**
  String get generalSupportMessage;

  /// No description provided for @orderSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, I would like to inquire about my order #{orderId}.'**
  String orderSupportMessage(String orderId);
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
