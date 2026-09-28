import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../manager/app_settings/app_settings_cubit.dart';
import '../../manager/app_settings/app_settings_state.dart';

class SupportAndSettingsWidget extends StatelessWidget {
  const SupportAndSettingsWidget({super.key});

  static const Color _whatsapp = Color(0xFF25D366);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<AppSettingsCubit>();
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    return Column(
      children: [
        PressableScale(
          pressedScale: 0.98,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _whatsapp.withValues(alpha: 0.18),
                  _whatsapp.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _whatsapp.withValues(alpha: 0.3)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // TODO: Open WhatsApp support action
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: _whatsapp,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: _whatsapp.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chat_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          l10n.contactSupport,
                          style: AppStyles.semiBold16(
                            context,
                          ).copyWith(fontSize: 14, color: _whatsapp),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _whatsapp.withValues(alpha: 0.15),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: _whatsapp,
                          // matchTextDirection: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.appSettings,
                        style: AppStyles.semiBold16(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<AppSettingsCubit, AppSettingsState>(
                    builder: (context, state) {
                      final isCurrentDark =
                          state.themeMode == ThemeMode.dark ||
                          (state.themeMode == ThemeMode.system &&
                              MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark);

                      return SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                RotationTransition(
                                  turns: Tween<double>(
                                    begin: 0.75,
                                    end: 1,
                                  ).animate(animation),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                ),
                            child: Icon(
                              isCurrentDark
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded,
                              key: ValueKey(isCurrentDark),
                              size: 20,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        title: Text(
                          l10n.darkMode,
                          style: AppStyles.medium14(context),
                        ),
                        value: isCurrentDark,
                        activeThumbColor: AppColors.accent,
                        activeTrackColor: AppColors.accent.withValues(
                          alpha: 0.35,
                        ),
                        onChanged: (val) => cubit.toggleTheme(val),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 4),
                  BlocBuilder<AppSettingsCubit, AppSettingsState>(
                    builder: (context, state) {
                      final isArabic = state.locale.languageCode == 'ar';

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.language_rounded,
                            size: 20,
                            color: AppColors.accent,
                          ),
                        ),
                        title: Text(
                          l10n.changeLanguage,
                          style: AppStyles.medium14(context),
                        ),
                        trailing: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.accent.withValues(
                              alpha: 0.12,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            final newLocale = isArabic
                                ? const Locale('en')
                                : const Locale('ar');
                            cubit.changeLocale(newLocale);
                          },
                          child: Text(
                            isArabic ? 'English' : 'العربية',
                            style: AppStyles.semiBold16(
                              context,
                            ).copyWith(fontSize: 13, color: AppColors.accent),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}