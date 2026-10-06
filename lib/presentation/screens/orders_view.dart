import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/constants/app_storage_keys.dart';
import 'package:mirrors_app/core/routing/app_routes.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/core/widgets/empty_state_widget.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/data/services/orders_firestore_service.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/manager/orders/orders_cubit.dart';
import 'package:mirrors_app/presentation/manager/orders/orders_state.dart';
import 'package:mirrors_app/presentation/widgets/orders/order_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final OrdersFirestoreService _firestoreService = OrdersFirestoreService();
  String _customerPhone = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomerPhone();
  }

  Future<void> _loadCustomerPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString(AppStorageKeys.customerPhone) ?? '';
    if (mounted) {
      setState(() {
        _customerPhone = savedPhone.trim();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Fallback: If no phone number is registered yet in customer profile
    if (_customerPhone.isEmpty) {
      return BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          return _buildOrdersList(context, state.orders, l10n);
        },
      );
    }

    // Real-time live sync from Firestore
    return StreamBuilder<List<OrderUiModel>>(
      stream: _firestoreService.getOrdersByPhoneStream(_customerPhone),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final firestoreOrders = snapshot.data ?? [];

        // If firestore has records show them, otherwise fallback to local saved orders
        if (firestoreOrders.isNotEmpty) {
          return _buildOrdersList(context, firestoreOrders, l10n);
        }

        return BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            return _buildOrdersList(context, state.orders, l10n);
          },
        );
      },
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    List<OrderUiModel> orders,
    AppLocalizations l10n,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: orders.isEmpty
          ? EmptyStateWidget(
              key: const ValueKey('empty_orders'),
              icon: Icons.receipt_long_rounded,
              title: l10n.ordersEmptyTitle,
              subtitle: l10n.ordersEmptySubtitle,
              buttonText: l10n.browseCatalog,
              onButtonPressed: () => context.go(AppRoutes.mainLayout),
            )
          : ListView.builder(
              key: const ValueKey('orders_list'),
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 14,
                bottom: 100,
              ),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return FadeSlideIn(
                  index: index,
                  child: OrderCard(
                    order: order,
                    onTap: () {
                      context.push(AppRoutes.orderDetails, extra: order);
                    },
                  ),
                );
              },
            ),
    );
  }
}