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

  @override
  String get framedMirrors => 'Framed Mirrors';

  @override
  String get adhesiveMirrors => 'Adhesive Mirrors';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get cm => 'cm';

  @override
  String get egp => 'EGP';

  @override
  String get viewInRoom => 'Preview';

  @override
  String get selectQuantity => 'Select Quantity';

  @override
  String get quarterDozen => '1/4 Dozen (3)';

  @override
  String get halfDozen => '1/2 Dozen (6)';

  @override
  String get oneDozen => '1 Dozen (12)';

  @override
  String get oneAndHalfDozen => '1.5 Dozen (18)';

  @override
  String get twoDozens => '2 Dozens (24)';

  @override
  String get unitWholesalePrice => 'Piece wholesale';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get piecesCount => 'pieces';

  @override
  String get orderNumber => 'Order #';

  @override
  String get orderReceived => 'Received';

  @override
  String get orderPreparing => 'Packaging';

  @override
  String get orderShipping => 'Shipped';

  @override
  String get orderDelivered => 'Delivered';

  @override
  String get items => 'items';

  @override
  String get viewDetails => 'View Details';

  @override
  String get userAccount => 'Account Info';

  @override
  String get storeOwnerOrCustomer => 'Customer / Store Owner';

  @override
  String get safetyAndGuide => 'Glass Handling & Installation Guide';

  @override
  String get safetyTip1 => 'Handle with care. Unbox on a soft flat surface.';

  @override
  String get safetyTip2 =>
      'Clean wall thoroughly with alcohol before sticking adhesive mirrors.';

  @override
  String get safetyTip3 =>
      'Use sturdy wall anchors for hanging rope-framed mirrors.';

  @override
  String get appSettings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get changeLanguage => 'Language';

  @override
  String get cartTitle => 'Shopping Cart';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shippingFee => 'Shipping';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Proceed to Checkout';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get cashOnDelivery => 'Cash on Delivery';

  @override
  String get vodafoneCash => 'Vodafone Cash';

  @override
  String get visaCard => 'Credit Card';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get shippingDetails => 'Shipping Details';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get address => 'Full Address';

  @override
  String get notesOptional => 'Delivery Notes (Optional)';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidPhone => 'Please enter a valid phone number';

  @override
  String get placeOrder => 'Confirm & Place Order';

  @override
  String get orderPlacedSuccess => 'Your order has been placed successfully!';

  @override
  String get goToOrders => 'Track My Order';

  @override
  String get depositTitle => 'Order Deposit (Vodafone Cash)';

  @override
  String get storeWalletLabel => 'Store wallet number for transfer:';

  @override
  String get copiedSuccessfully => 'Wallet number copied successfully';

  @override
  String get copyTooltip => 'Copy number';

  @override
  String get senderWalletLabel => 'Wallet number transferred from';

  @override
  String get senderWalletValidation =>
      'Please enter the transfer wallet number';

  @override
  String depositAmountLabel(int amount, String currency) {
    return 'Deposit amount (Min 50% = $amount $currency)';
  }

  @override
  String minDepositError(int amount, String currency) {
    return 'Deposit cannot be less than 50% ($amount $currency)';
  }

  @override
  String maxDepositError(int amount, String currency) {
    return 'Amount cannot exceed total ($amount $currency)';
  }

  @override
  String get depositPaidNow => 'Deposit paid now:';

  @override
  String get remainingOnDelivery => 'Remaining upon delivery:';

  @override
  String get confirmOrderButton => 'Confirm Order & Submit Deposit';

  @override
  String get orderPlacedSub =>
      'The store will verify your deposit transfer and begin preparing your mirrors immediately.';

  @override
  String get courierContactPhone => 'Courier contact phone number';

  @override
  String get orderTrackingTitle => 'Order Progress & Delivery';

  @override
  String get notRegistered => 'Not specified';

  @override
  String get depositAndPaymentDetails => 'Payment & Deposit Details';

  @override
  String itemsCountTitle(int count) {
    return 'Purchased items ($count)';
  }

  @override
  String mirrorUnitDimensions(String dimensions) {
    return 'Mirror $dimensions cm';
  }

  @override
  String get depositPaidLabel => 'Paid deposit:';

  @override
  String get deliveryNotes => 'Notes';

  @override
  String get quantity => 'Quantity';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get whatsappError =>
      'Could not open WhatsApp. Please ensure it is installed on your device.';

  @override
  String get generalSupportMessage =>
      'Hello, I would like to inquire about customized mirrors.';

  @override
  String orderSupportMessage(String orderId) {
    return 'Hello, I would like to inquire about my order #$orderId.';
  }

  @override
  String get editProfileTitle => 'Edit Delivery Information';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get infoSavedSuccess => 'Information saved successfully';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String cancelOrderDialogTitle(String orderId) {
    return 'Cancel Order #$orderId?';
  }

  @override
  String get cancelOrderDialogMessage =>
      'Are you sure you want to cancel this order? The store support team will contact you regarding your deposit refund.';

  @override
  String get confirmCancelButton => 'Yes, Cancel';

  @override
  String get keepOrderButton => 'Keep Order';

  @override
  String get orderCancelledSnackbar => 'Order has been cancelled successfully';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get cartEmptyTitle => 'Your Cart is Empty';

  @override
  String get cartEmptySubtitle =>
      'Looks like you haven\'t added any mirrors yet. Discover our collection and find the perfect match for your space.';

  @override
  String get startShopping => 'Explore Mirrors';

  @override
  String get ordersEmptyTitle => 'No Orders Yet';

  @override
  String get ordersEmptySubtitle =>
      'You haven\'t placed any mirror orders yet. When you do, you can track their status right here.';

  @override
  String get browseCatalog => 'Start Shopping';

  @override
  String get filterAll => 'All';

  @override
  String get filterStandard => 'Standard';

  @override
  String get filterSpecialSizes => 'Special Sizes';

  @override
  String get filterWithShelf => 'With Shelf';

  @override
  String get mirrorWithShelf => 'Framed Mirror with Shelf';

  @override
  String get undo => 'Undo';

  @override
  String get orderCreatedSuccess => 'Order placed successfully';

  @override
  String get statusReceived => 'New Order';

  @override
  String get statusDepositConfirmed => 'Deposit Confirmed';

  @override
  String get statusPreparing => 'Preparing';

  @override
  String get statusShipping => 'Out for Delivery';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get orderCancelledRefundNote =>
      'If you paid a deposit, it will be refunded to your wallet shortly.';

  @override
  String get deliveryTimelineTitle => 'Estimated Delivery Time';

  @override
  String get deliveryTimelineDesc =>
      'Preparation takes 2 to 3 days, and your order will be delivered within 24 hours of dispatch.';
}
