import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/routing/app_router.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/manager/cart/cart_cubit.dart';
import 'package:mirrors_app/presentation/manager/cart/cart_state.dart';
import 'package:mirrors_app/presentation/screens/orders_view.dart';
import 'package:mirrors_app/presentation/screens/profile_view.dart';
import 'package:mirrors_app/presentation/screens/retail_view.dart';
import 'package:mirrors_app/presentation/screens/wholesale_view.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RetailView(),
    WholesaleView(),
    OrdersView(),
    ProfileView(),
  ];

  Widget _buildCartAction(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocSelector<CartCubit, CartState, int>(
      selector: (state) => state.totalCount,
      builder: (context, totalCount) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                context.push(AppRouter.cart);
              },
            ),
            if (totalCount > 0)
              PositionedDirectional(
                top: 6,
                end: 4,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        totalCount > 99 ? '99+' : '$totalCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(l10n.appTitle),
        actions: [
          _buildCartAction(context),
          const SizedBox(width: 6),
          _buildAction(
            context,
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: () {
              // TODO: Open WhatsApp support action sheet
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          CustomBottomNavBarItem(
            icon: Icons.storefront_outlined,
            activeIcon: Icons.storefront,
            label: l10n.retailTab,
          ),
          CustomBottomNavBarItem(
            icon: Icons.inventory_2_outlined,
            activeIcon: Icons.inventory_2,
            label: l10n.wholesaleTab,
          ),
          CustomBottomNavBarItem(
            icon: Icons.local_shipping_outlined,
            activeIcon: Icons.local_shipping,
            label: l10n.ordersTab,
          ),
          CustomBottomNavBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: l10n.profileTab,
          ),
        ],
      ),
    );
  }
}