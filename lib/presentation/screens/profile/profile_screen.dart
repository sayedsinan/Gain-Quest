import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/widgets/achievement_section.dart';
import 'package:gain_quest/presentation/widgets/profile_header.dart';
import 'package:gain_quest/presentation/widgets/settings_section.dart';
import 'package:gain_quest/presentation/widgets/state_section.dart';
import 'package:get/get.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';
import 'package:gain_quest/presentation/controllers/theme_controller.dart';
import 'package:gain_quest/core/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProfileHeader(),
            const SizedBox(height: 20),
            const StatsSection(),
            const SizedBox(height: 20),
            const AchievementsSection(),
            const SizedBox(height: 20),
            SettingsSection(),
            const SizedBox(height: 20),
            CustomButton(
              text: "Logout",
              onPressed: () => authController.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}



