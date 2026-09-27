import 'package:flutter/material.dart';
import 'package:mirrors_app/presentation/widgets/profile_and_support.dart/glass_safety_guide_widget.dart';
import 'package:mirrors_app/presentation/widgets/profile_and_support.dart/support_and_settings_widget.dart';
import 'package:mirrors_app/presentation/widgets/profile_and_support.dart/user_profile_card.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 14,
        bottom: 100, // padding above custom bottom navigation bar
      ),
      children: const [
        UserProfileCard(),
        SizedBox(height: 16),
        GlassSafetyGuideWidget(),
        SizedBox(height: 16),
        SupportAndSettingsWidget(),
      ],
    );
  }
}