import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/manager/app_settings/app_settings_cubit.dart';
import 'package:mirrors_app/presentation/manager/app_settings/app_settings_state.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

class SupportAndSettingsWidget extends StatelessWidget {
  const SupportAndSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<AppSettingsCubit>();

    return Column(
      children: [
        // WhatsApp Action Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF25D366).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF25D366).withValues(alpha: 0.3),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // TODO: Open WhatsApp with pre-filled message
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_rounded,
                      color: Color(0xFF25D366),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.contactSupport,
                        style: AppStyles.semiBold16(context).copyWith(
                          fontSize: 14,
                          color: const Color(0xFF25D366),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Color(0xFF25D366),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Settings Section (Theme & Locale)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.appSettings, style: AppStyles.semiBold16(context)),
              const SizedBox(height: 10),

              // Theme Switch
              BlocBuilder<AppSettingsCubit, AppSettingsState>(
                builder: (context, state) {
                  final isCurrentDark =
                      state.themeMode == ThemeMode.dark ||
                      (state.themeMode == ThemeMode.system &&
                          MediaQuery.of(context).platformBrightness ==
                              Brightness.dark);

                  return SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.dark_mode_outlined, size: 20),
                    title: Text(
                      l10n.darkMode,
                      style: AppStyles.medium14(context),
                    ),
                    value: isCurrentDark,
                    activeThumbColor: AppColors.accent,
                    onChanged: (val) => cubit.toggleTheme(val),
                  );
                },
              ),

              const Divider(height: 1),

              // Language Switch (Arabic / English)
              BlocBuilder<AppSettingsCubit, AppSettingsState>(
                builder: (context, state) {
                  final isArabic = state.locale.languageCode == 'ar';

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.language_rounded, size: 20),
                    title: Text(
                      l10n.changeLanguage,
                      style: AppStyles.medium14(context),
                    ),
                    trailing: TextButton(
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
      ],
    );
  }
}
