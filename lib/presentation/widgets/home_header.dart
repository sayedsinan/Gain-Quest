import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gain_quest/presentation/controllers/auth_controller.dart';
import 'package:gain_quest/presentation/controllers/theme_controller.dart';

class HomeHeader extends StatelessWidget {
  final AuthController authController;
  final ThemeController themeController;

  const HomeHeader({
    Key? key,
    required this.authController,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                    'Hello, ${authController.currentUser.value?.name ?? 'User'}! 👋',
                    style: Get.theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 4),
              Text(
                'Ready to win big today?',
                style: Get.theme.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Obx(() => IconButton(
                  icon: Icon(
                    themeController.isDarkMode.value
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: themeController.toggleTheme,
                  tooltip: 'Toggle Theme',
                )),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                Get.snackbar(
                  'Info',
                  'Notifications feature coming soon!',
                  snackPosition: SnackPosition.TOP,
                );
              },
              tooltip: 'Notifications',
            ),
          ],
        ),
      ],
    );
  }
}
