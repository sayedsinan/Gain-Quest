import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/controllers/theme_controller.dart';
import 'package:get/get.dart';

class SettingsSection extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Obx(() {
              return Switch(
                value: themeController.isDarkMode.value,
                onChanged: (val) => themeController.toggleTheme(),
              );
            }),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }
}

