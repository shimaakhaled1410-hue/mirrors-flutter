import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomBottomNavBarItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const CustomBottomNavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomBottomNavBarItem> items;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  static const double _height = 68;
  static const double _radius = 30;
  static const Duration _duration = Duration(milliseconds: 380);
  static const Curve _curve = Curves.easeOutCubic;

  void _handleTap(int index) {
    if (index != currentIndex) HapticFeedback.selectionClick();
    onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final count = items.length;

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.15,
      child: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.14),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                height: _height,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                      .withValues(alpha: isDark ? 0.82 : 0.9),
                  borderRadius: BorderRadius.circular(_radius),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.lightBorder,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    // The selected tab gets a wider pill (icon + label side by
                    // side); the others share the remaining width equally.
                    final selectedW =
                        count > 1 ? w * (count <= 3 ? 0.42 : 0.36) : w;
                    final otherW =
                        count > 1 ? (w - selectedW) / (count - 1) : 0.0;
                    final pillStart = currentIndex * otherW;

                    return Stack(
                      children: [
                        AnimatedPositionedDirectional(
                          duration: _duration,
                          curve: _curve,
                          start: pillStart,
                          top: 0,
                          bottom: 0,
                          width: selectedW,
                          child: const _Pill(),
                        ),
                        Positioned.fill(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(count, (index) {
                              final isSelected = currentIndex == index;
                              return AnimatedContainer(
                                duration: _duration,
                                curve: _curve,
                                width: isSelected ? selectedW : otherW,
                                child: _NavItem(
                                  item: items[index],
                                  isSelected: isSelected,
                                  isDark: isDark,
                                  onTap: () => _handleTap(index),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The gradient pill behind the selected tab.
class _Pill extends StatelessWidget {
  const _Pill();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.45),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final CustomBottomNavBarItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inactive =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final Widget content = isSelected
        ? Row(
            key: const ValueKey('selected'),
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.activeIcon, size: 23, color: AppColors.accentSoft),
              const SizedBox(width: 8),
              Text(
                item.label,
                maxLines: 1,
                style: AppStyles.semiBold16(context).copyWith(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ],
          )
        : Column(
            key: const ValueKey('idle'),
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 23, color: inactive),
              const SizedBox(height: 3),
              Text(
                item.label,
                maxLines: 1,
                style: AppStyles.regular12(context).copyWith(
                  fontSize: 12,
                  color: inactive,
                ),
              ),
            ],
          );

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          splashColor: AppColors.accentSoft.withValues(alpha: 0.12),
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              // FittedBox keeps the content inside the tab while its width animates.
              child: FittedBox(
                key: ValueKey(isSelected),
                fit: BoxFit.scaleDown,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}