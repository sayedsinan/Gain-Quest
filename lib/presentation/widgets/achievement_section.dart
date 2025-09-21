import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/widgets/achievement_badge.dart';
import 'package:get/get.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Text(
            'Achievements',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AchievementBadge(
                icon: Icons.emoji_events,
                label: 'First Win',
                color: Colors.amber,
              ),
              AchievementBadge(
                icon: Icons.military_tech,
                label: 'Top Better',
                color: Colors.blue,
              ),
              AchievementBadge(
                icon: Icons.flash_on,
                label: 'Streak Master',
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

