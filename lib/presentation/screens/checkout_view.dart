import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/constants/app_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/routing/app_routes.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_snack_bar.dart';
import '../../core/utils/app_styles.dart';
import '../../core/widgets/animated_widgets.dart';
import '../../l10n/app_localizations.dart';
import '../manager/cart/cart_cubit.dart';
import '../manager/cart/cart_state.dart';
import '../manager/orders/orders_cubit.dart';
import '../widgets/checkout/checkout_deposit_section.dart';
import '../widgets/checkout/checkout_financial_summary.dart';
import '../widgets/checkout/checkout_shipping_section.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _senderWalletController = TextEditingController();
  final _depositController = TextEditingController();
  final _notesController = TextEditingController();

  static const double _shippingFee = 50.0;
  late final String _storeWalletNumber;

  @override
  void initState() {
    super.initState();
    _storeWalletNumber = dotenv.env['WALLET_PHONE_NUMBER'] ?? '01012345678';
    final subtotal = context.read<CartCubit>().state.subtotal;
    final minDeposit = (subtotal + _shippingFee) * 0.50;
    _depositController.text = minDeposit.toInt().toString();

    _loadDefaultCustomerInfo();
  }

  Future<void> _loadDefaultCustomerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(AppStorageKeys.customerName);
    final savedPhone = prefs.getString(AppStorageKeys.customerPhone);
    final savedAddress = prefs.getString(AppStorageKeys.customerAddress);

    if (!mounted) return;
    if (savedName != null && savedName.isNotEmpty) {
      _nameController.text = savedName;
    }
    if (savedPhone != null && savedPhone.isNotEmpty) {
      _phoneController.text = savedPhone;
    }
    if (savedAddress != null && savedAddress.isNotEmpty) {
      _addressController.text = savedAddress;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _senderWalletController.dispose();
    _depositController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onConfirmOrder(BuildContext context, CartState cartState) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final total = cartState.subtotal + _shippingFee;
    final depositPaid = double.tryParse(_depositController.text) ?? 0.0;
    final remaining = (total - depositPaid).clamp(0.0, total);

    final customerName = _nameController.text.trim();
    final phoneNumber = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final senderWalletNumber = _senderWalletController.text.trim();
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStorageKeys.customerName, customerName);
    await prefs.setString(AppStorageKeys.customerPhone, phoneNumber);
    await prefs.setString(AppStorageKeys.customerAddress, address);

    if (!context.mounted) return;

    final cachedItems = List.of(cartState.items);

    await context.read<OrdersCubit>().placeOrder(
          items: cachedItems,
          totalPrice: total,
          depositAmount: depositPaid,
          remainingAmount: remaining,
          customerName: customerName,
          phoneNumber: phoneNumber,
          address: address,
          paymentMethod: l10n.vodafoneCash,
          senderWalletNumber: senderWalletNumber,
          notes: notes,
        );

    if (!context.mounted) return;

    context.read<CartCubit>().clearCart();

    context.go(AppRoutes.mainLayout);

    AppSnackBar.showSuccess(
      context,
      message: l10n.orderCreatedSuccess,
      actionLabel: l10n.undo,
      onAction: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkoutTitle),
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          final total = cartState.subtotal + _shippingFee;
          final minDeposit = total * 0.50;

          return Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(16),
              children: [
                FadeSlideIn(
                  index: 0,
                  child: CheckoutShippingSection(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                    notesController: _notesController,
                  ),
                ),
                const SizedBox(height: 16),
                FadeSlideIn(
                  index: 1,
                  child: CheckoutDepositSection(
                    storeWalletNumber: _storeWalletNumber,
                    senderWalletController: _senderWalletController,
                    depositController: _depositController,
                    minDeposit: minDeposit,
                    total: total,
                  ),
                ),
                const SizedBox(height: 16),
                FadeSlideIn(
                  index: 2,
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _depositController,
                    builder: (context, value, _) {
                      final depositPaid = double.tryParse(value.text) ?? 0.0;
                      final remaining = (total - depositPaid).clamp(0.0, total);

                      return CheckoutFinancialSummary(
                        subtotal: cartState.subtotal,
                        shippingFee: _shippingFee,
                        total: total,
                        depositPaid: depositPaid,
                        remaining: remaining,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                FadeSlideIn(
                  index: 3,
                  child: PressableScale(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _onConfirmOrder(context, cartState),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                l10n.confirmOrderButton,
                                style: AppStyles.semiBold16(
                                  context,
                                ).copyWith(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}