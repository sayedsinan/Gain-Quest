import 'package:flutter/material.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:get/get.dart';

class TeamInfoSection extends StatelessWidget {
  final TeamModel team;

  const TeamInfoSection({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Get.theme.primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  team.category,
                  style: TextStyle(color: Get.theme.primaryColor, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Icon(Icons.people_outline, size: 16, color: Get.theme.colorScheme.onSurface.withOpacity(0.6)),
             const  SizedBox(width: 4),
              Text('${team.followersCount} followers',
                  style: Get.theme.textTheme.bodySmall
                      ?.copyWith(color: Get.theme.colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
          const SizedBox(height: 16),
          Text('About the Team', style: Get.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(team.description,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: Get.theme.colorScheme.onSurface.withOpacity(0.8),
              )),
        ],
      ),
    );
  }
}
