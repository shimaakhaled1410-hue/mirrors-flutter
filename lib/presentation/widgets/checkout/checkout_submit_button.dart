import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';

class CheckoutSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  final bool isLoading;

  const CheckoutSubmitButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      child: Opacity(
        opacity: isLoading ? 0.85 : 1,
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
              onTap: isLoading ? null : onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.semiBold16(context).copyWith(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}