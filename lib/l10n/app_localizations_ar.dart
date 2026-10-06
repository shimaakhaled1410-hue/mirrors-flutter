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

  @override
  String get selectQuantity => 'اختر الكمية';

  @override
  String get quarterDozen => 'ربع دستة (3)';

  @override
  String get halfDozen => 'نص دستة (6)';

  @override
  String get oneDozen => 'دستة (12)';

  @override
  String get oneAndHalfDozen => 'دستة ونص (18)';

  @override
  String get twoDozens => 'دستتين (24)';

  @override
  String get unitWholesalePrice => 'سعر القطعة جملة';

  @override
  String get totalPrice => 'الإجمالي';

  @override
  String get piecesCount => 'قطع';

  @override
  String get orderNumber => 'طلب رقم #';

  @override
  String get orderReceived => 'تم الاستلام';

  @override
  String get orderPreparing => 'تجهيز وتغليف';

  @override
  String get orderShipping => 'مع الشحن';

  @override
  String get orderDelivered => 'تم التوصيل';

  @override
  String get items => 'منتجات';

  @override
  String get viewDetails => 'تفاصيل الطلب';

  @override
  String get userAccount => 'بيانات الحساب';

  @override
  String get storeOwnerOrCustomer => 'عميل قطاعي / صاحب محل';

  @override
  String get safetyAndGuide => 'دليل التركيب وإرشادات الزجاج';

  @override
  String get safetyTip1 => 'التعامل بحذر. افتح التغليف على سطح مستوٍ ومبطن.';

  @override
  String get safetyTip2 =>
      'نظّف الجدار جيداً بالكحول وجففه قبل تثبيت شريط اللصق.';

  @override
  String get safetyTip3 =>
      'استخدم خطافات حائط متينة ومناسبة لتعليق مرايات الخيط.';

  @override
  String get contactSupport => 'تواصل مع الدعم الفني';

  @override
  String get appSettings => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get changeLanguage => 'اللغة';

  @override
  String get cartTitle => 'سلة المشتريات';

  @override
  String get emptyCart => 'سلة المشتريات فارغة';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get shippingFee => 'مصاريف الشحن';

  @override
  String get total => 'الإجمالي الكلي';

  @override
  String get checkout => 'إتمام الطلب';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get vodafoneCash => 'فودافون كاش';

  @override
  String get visaCard => 'بطاقة بنكية';

  @override
  String get checkoutTitle => 'إتمام الطلب';

  @override
  String get shippingDetails => 'بيانات الشحن والتوصيل';

  @override
  String get fullName => 'الاسم بالكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get address => 'العنوان بالتفصيل';

  @override
  String get notesOptional => 'ملاحظات التوصيل (اختياري)';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get invalidPhone => 'يرجى إدخال رقم هاتف صحيح';

  @override
  String get placeOrder => 'تأكيد وإرسال الطلب';

  @override
  String get orderPlacedSuccess => 'تم تسجيل طلبك بنجاح!';

  @override
  String get goToOrders => 'تتبع طلبي';

  @override
  String get depositTitle => 'سداد عربون الطلب (فودافون كاش)';

  @override
  String get storeWalletLabel => 'رقم محفظة المتجر للتحويل:';

  @override
  String get copiedSuccessfully => 'تم نسخ رقم المحفظة بنجاح';

  @override
  String get copyTooltip => 'نسخ الرقم';

  @override
  String get senderWalletLabel => 'رقم المحفظة التي قمت بالتحويل منها';

  @override
  String get senderWalletValidation =>
      'يرجى كتابة رقم المحفظة للتأكد من التحويل';

  @override
  String depositAmountLabel(int amount, String currency) {
    return 'مبلغ العربون (الحد الأدنى 50% = $amount $currency)';
  }

  @override
  String minDepositError(int amount, String currency) {
    return 'يجب ألا يقل العربون عن 50% ($amount $currency)';
  }

  @override
  String maxDepositError(int amount, String currency) {
    return 'المبلغ لا يمكن أن يتجاوز الإجمالي ($amount $currency)';
  }

  @override
  String get depositPaidNow => 'العربون المدفوع الآن:';

  @override
  String get remainingOnDelivery => 'المتبقي للمندوب عند الاستلام:';

  @override
  String get confirmOrderButton => 'تأكيد الطلب وإرسال إثبات العربون';

  @override
  String get orderPlacedSub =>
      'سيقوم المتجر بمراجعة تحويل العربون والبدء في تجهيز وتفصيل المرآة فوراً.';

  @override
  String get courierContactPhone => 'رقم هاتف التواصل مع المندوب';

  @override
  String get orderTrackingTitle => 'مرحلة التنفيذ والتوصيل';

  @override
  String get notRegistered => 'غير مسجل';

  @override
  String get depositAndPaymentDetails => 'بيانات السداد والعربون';

  @override
  String itemsCountTitle(int count) {
    return 'المنتجات ($count)';
  }

  @override
  String mirrorUnitDimensions(String dimensions) {
    return 'مرآة مقاس $dimensions سم';
  }

  @override
  String get depositPaidLabel => 'العربون المدفوع:';

  @override
  String get deliveryNotes => 'ملاحظات';

  @override
  String get quantity => 'الكمية';

  @override
  String get whatsappError =>
      'تعذر فتح تطبيق واتساب. يرجى التأكد من تثبيته على جهازك.';

  @override
  String get generalSupportMessage =>
      'مرحباً، أود الاستفسار عن تفصيل وتجهيز المرايات.';

  @override
  String orderSupportMessage(String orderId) {
    return 'مرحباً، أود الاستفسار بخصوص الطلب رقم #$orderId.';
  }

  @override
  String get editProfileTitle => 'تعديل بيانات التوصيل';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get infoSavedSuccess => 'تم حفظ البيانات بنجاح';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String cancelOrderDialogTitle(String orderId) {
    return 'إلغاء الطلب #$orderId؟';
  }

  @override
  String get cancelOrderDialogMessage =>
      'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟ سيتواصل معك فريق الدعم بشأن استرداد العربون.';

  @override
  String get confirmCancelButton => 'نعم، تأكيد الإلغاء';

  @override
  String get keepOrderButton => 'الاحتفاظ بالطلب';

  @override
  String get orderCancelledSnackbar => 'تم إلغاء الطلب بنجاح';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get cartEmptyTitle => 'سلة المشتريات فارغة';

  @override
  String get cartEmptySubtitle =>
      'لم تقم بإضافة أي مرايا بعد. تصفح تشكيلتنا المميزة واختر ما يناسب مساحتك.';

  @override
  String get startShopping => 'تصفح المرايا';

  @override
  String get ordersEmptyTitle => 'لا توجد طلبات سابقة';

  @override
  String get ordersEmptySubtitle =>
      'لم تقم بعمل أي طلبات حتى الآن. عند إتمام طلبك، ستتمكن من متابعة حالته وتفاصيله هنا.';

  @override
  String get browseCatalog => 'ابدأ التسوق الآن';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterStandard => 'المقاسات العادية';

  @override
  String get filterSpecialSizes => 'مقاسات خاصة';

  @override
  String get filterWithShelf => 'مرايا برَف';

  @override
  String get mirrorWithShelf => 'مرآة بإطار مع رف زجاجي';

  @override
  String get undo => 'تراجع';

  @override
  String get orderCreatedSuccess => 'تم تسجيل طلبك بنجاح';

  @override
  String get adminAccess => 'دخول الإدارة';

  @override
  String get adminPinPrompt => 'أدخل رمز PIN للمتابعة';

  @override
  String get invalidPin => 'رمز PIN غير صحيح';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';
}
