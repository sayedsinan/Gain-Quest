import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/controllers/team_controller.dart';
import 'package:get/get.dart';

class ErrorState extends StatelessWidget {
  final TeamsController controller;

  const ErrorState({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Get.theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Error Loading Teams',
            style: Get.theme.textTheme.headlineMedium?.copyWith(color: Get.theme.colorScheme.error),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.bodyMedium
                  ?.copyWith(color: Get.theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () => controller.loadTeams(), child: const Text('Retry')),
              const SizedBox(width: 12),
              TextButton(onPressed: () => controller.clearError(), child: const Text('Dismiss')),
            ],
          ),
        ],
      ),
    );
  }
}

