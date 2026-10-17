import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/whatsapp_helper.dart';
import '../../core/widgets/custom_bottom_nav_bar.dart';
import '../../l10n/app_localizations.dart';
import '../manager/cart/cart_cubit.dart';
import '../manager/cart/cart_state.dart';
import 'orders_view.dart';
import 'profile_view.dart';
import 'retail_view.dart';
import 'wholesale_view.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentIndex = 0;
  DateTime? _lastBackPressTime;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const RetailView(),
      const WholesaleView(),
      OrdersView(
        onBrowseCatalog: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      const ProfileView(),
    ];
  }

  void _handleBackNavigation(bool didPop) {
    if (didPop) return;

    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return;
    }

    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'اضغط مرة أخرى للخروج من التطبيق'
                : 'Press back again to exit',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }

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
              onPressed: () => context.push(AppRoutes.cart),
            ),
            if (totalCount > 0)
              PositionedDirectional(
                top: 6,
                end: 6,
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
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        totalCount > 99 ? '99+' : '$totalCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
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

  Widget _buildAction({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.lightSurface,
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _handleBackNavigation(didPop),
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          centerTitle: false,
          title: Text(l10n.appTitle),
          actions: [
            _buildCartAction(context),
            const SizedBox(width: 8),
            _buildAction(
              context: context,
              icon: Icons.chat_bubble_outline_rounded,
              onPressed: () {
                WhatsAppHelper.openChat(
                  context: context,
                  customMessage: l10n.generalSupportMessage,
                  errorMessage: l10n.whatsappError,
                );
              },
            ),
            const SizedBox(width: 12),
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
              activeIcon: Icons.storefront_rounded,
              label: l10n.retailTab,
            ),
            CustomBottomNavBarItem(
              icon: Icons.inventory_2_outlined,
              activeIcon: Icons.inventory_2_rounded,
              label: l10n.wholesaleTab,
            ),
            CustomBottomNavBarItem(
              icon: Icons.local_shipping_outlined,
              activeIcon: Icons.local_shipping_rounded,
              label: l10n.ordersTab,
            ),
            CustomBottomNavBarItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: l10n.profileTab,
            ),
          ],
        ),
      ),
    );
  }
}