import 'package:flutter/material.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:gain_quest/presentation/widgets/stats_card.dart';
import 'package:get/get.dart';

class TeamStatSection extends StatelessWidget {
  final TeamModel team;

  const TeamStatSection({super.key, required this.team});

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
          Text('Performance Stats', style: Get.theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Win Rate',
                  value: '${team.winRate.toStringAsFixed(1)}%',
                  icon: Icons.emoji_events,
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Total Challenges',
                  value: '${team.totalChallenges}',
                  icon: Icons.flag,
                  color: Get.theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Challenges Won',
                  value: '${team.challengesWon}',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
           const    SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Followers',
                  value: '${team.followersCount}',
                  icon: Icons.people,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
