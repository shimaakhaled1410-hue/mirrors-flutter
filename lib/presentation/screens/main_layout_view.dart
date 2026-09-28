import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/routing/app_router.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
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
          _buildAction(
            context,
            icon: Icons.shopping_bag_outlined,
            onPressed: () {
              context.push(AppRouter.cart);
            },
          ),
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