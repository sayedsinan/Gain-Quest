import 'package:flutter/material.dart';
import 'package:gain_quest/core/widgets/custom_button.dart';
import 'package:get/get.dart';

class LiveStreamSection extends StatelessWidget {
  const LiveStreamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:const  EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                   const SizedBox(width: 4),
                    const Text('LIVE',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('Team is Live!', style: Get.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
         const SizedBox(height: 8),
          Text('Join the live stream to see what the team is working on right now!',
              style: Get.theme.textTheme.bodyMedium?.copyWith(color: Get.theme.colorScheme.onSurface.withOpacity(0.7))),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Watch Live Stream',
            onPressed: () => Get.snackbar('Info', 'Live stream feature coming soon!'),
            backgroundColor: Colors.red,
            icon: Icons.play_arrow,
          ),
        ],
      ),
    );
  }
}
