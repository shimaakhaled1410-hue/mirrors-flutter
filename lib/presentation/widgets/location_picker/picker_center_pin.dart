import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';

class PickerCenterPin extends StatelessWidget {
  final ValueListenable<bool> busy;

  const PickerCenterPin({super.key, required this.busy});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: busy,
              builder: (context, isBusy, child) => AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.only(bottom: isBusy ? 62 : 48),
                child: child,
              ),
              child: const Icon(
                Icons.location_on_rounded,
                size: 48,
                color: AppColors.accent,
              ),
            ),
            // The point the pin is aiming at.
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}