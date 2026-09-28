import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/routing/app_routes.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/manager/cart/cart_cubit.dart';
import 'package:mirrors_app/presentation/manager/cart/cart_state.dart';
import 'package:mirrors_app/presentation/manager/orders/order_cubit.dart';

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
  final _notesController = TextEditingController();

  String _selectedPayment = 'cash';
  static const double _shippingFee = 50.0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onConfirmOrder(BuildContext context, CartState cartState) {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final total = cartState.subtotal + _shippingFee;

    // 1. Create order in OrdersCubit
    context.read<OrdersCubit>().placeOrder(
          items: cartState.items,
          totalPrice: total,
          customerName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          paymentMethod: _selectedPayment,
        );

    // 2. Clear current cart
    context.read<CartCubit>().clearCart();

    // 3. Show Success Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.accent,
                  size: 44,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.orderPlacedSuccess,
                textAlign: TextAlign.center,
                style: AppStyles.bold18(dialogContext),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.go(AppRoutes.mainLayout);
                  },
                  child: Text(
                    l10n.goToOrders,
                    style: AppStyles.semiBold16(dialogContext)
                        .copyWith(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkoutTitle),
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          final total = cartState.subtotal + _shippingFee;

          return Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // Shipping details container
                FadeSlideIn(
                  index: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_shipping_outlined,
                                color: AppColors.accent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.shippingDetails,
                              style: AppStyles.semiBold16(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nameController,
                          label: l10n.fullName,
                          icon: Icons.person_outline,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? l10n.fieldRequired
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _phoneController,
                          label: l10n.phoneNumber,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.fieldRequired;
                            }
                            if (v.trim().length < 10) {
                              return l10n.invalidPhone;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _addressController,
                          label: l10n.address,
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? l10n.fieldRequired
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _buildTextField(
                          controller: _notesController,
                          label: l10n.notesOptional,
                          icon: Icons.note_alt_outlined,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Methods
                FadeSlideIn(
                  index: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.paymentMethod,
                          style: AppStyles.semiBold16(context),
                        ),
                        const SizedBox(height: 12),
                        _buildRadioTile(
                          title: l10n.cashOnDelivery,
                          subtitle: 'الدفع نقداً للمندوب عند وصول المرآة',
                          value: 'cash',
                          icon: Icons.payments_outlined,
                        ),
                        const Divider(height: 12),
                        _buildRadioTile(
                          title: l10n.vodafoneCash,
                          subtitle: 'تحويل للمحفظة: 01012345678',
                          value: 'vodafone',
                          icon: Icons.phone_android_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Order Cost Summary
                FadeSlideIn(
                  index: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.subtotal,
                                style: AppStyles.regular14(context)),
                            Text('${cartState.subtotal.toInt()} ${l10n.egp}',
                                style: AppStyles.medium14(context)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.shippingFee,
                                style: AppStyles.regular14(context)),
                            Text('${_shippingFee.toInt()} ${l10n.egp}',
                                style: AppStyles.medium14(context)),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.total,
                                style: AppStyles.bold18(context)),
                            Text(
                              '${total.toInt()} ${l10n.egp}',
                              style: AppStyles.bold16Accent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
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
                                l10n.placeOrder,
                                style: AppStyles.semiBold16(context).copyWith(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: AppStyles.medium14(context),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: AppColors.accent),
        filled: true,
        fillColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildRadioTile({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: _selectedPayment,
      activeColor: AppColors.accent,
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: AppColors.accent),
      title: Text(title, style: AppStyles.semiBold16(context).copyWith(fontSize: 14)),
      subtitle: Text(subtitle, style: AppStyles.regular12(context)),
      onChanged: (val) {
        if (val != null) {
          setState(() => _selectedPayment = val);
        }
      },
    );
  }
}