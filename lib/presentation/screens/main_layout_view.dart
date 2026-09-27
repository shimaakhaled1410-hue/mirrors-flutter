import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/screens/orders_view.dart';
import 'package:mirrors_app/presentation/screens/profile_view.dart';
import 'package:mirrors_app/presentation/screens/retail_view.dart';
import 'package:mirrors_app/presentation/screens/wholesale_view.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true, // Allows content to show gracefully behind the floating bar
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              // TODO: Navigate to cart view
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () {
              // TODO: Open WhatsApp support action sheet
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
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