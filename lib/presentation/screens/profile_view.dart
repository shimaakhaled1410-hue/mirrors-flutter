import 'package:flutter/material.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/presentation/widgets/profile_and_support/glass_safety_guide_widget.dart';
import 'package:mirrors_app/presentation/widgets/profile_and_support/support_and_settings_widget.dart';
import 'package:mirrors_app/presentation/widgets/profile_and_support/user_profile_card.dart';
import 'package:mirrors_app/presentation/widgets/profile_and_support/admin_access_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding:
          const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 100),
      children: const [
        FadeSlideIn(index: 0, child: UserProfileCard()),
        SizedBox(height: 16),
        FadeSlideIn(index: 1, child: GlassSafetyGuideWidget()),
        SizedBox(height: 16),
        FadeSlideIn(index: 2, child: SupportAndSettingsWidget()),
        SizedBox(height: 24),
        FadeSlideIn(index: 3, child: AdminAccessButton()),
      ],
    );
  }
}