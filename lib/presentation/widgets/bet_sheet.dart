import 'package:flutter/material.dart';
import 'package:get/get.dart';
class QuickBetSheet extends StatelessWidget {
  const QuickBetSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
          ),
          Text(
            'Quick Bet',
            style: Get.theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Browse active challenges to place your next winning bet!',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Navigate to challenges or home screen
            },
            child: Text('View Challenges'),
          ),
          SizedBox(height: 12),
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}