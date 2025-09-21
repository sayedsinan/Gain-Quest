import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';
import 'package:gain_quest/presentation/widgets/shimmer_state.dart';
import 'package:get/get.dart';

import '../../core/utils/formatters.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCards extends StatelessWidget {
  final AuthController authController;

  const StatsCards({
    super.key,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = authController.currentUser.value;
      if (user == null) {
        return const ShimmerStats();
      }

      return AnimationLimiter(
        child: Row(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              Expanded(
                child: StatCard(
                  title: 'Credits',
                  value: Formatters.formatCredits(user.credits),
                  icon: Icons.account_balance_wallet,
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
             const   SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Total Winnings',
                  value: Formatters.formatCredits(user.totalWinnings),
                  icon: Icons.trending_up,
                  color: Color(0xFFFFD93D),
                ),
              ),
             const  SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Win Rate',
                  value: Formatters.formatWinRate(user.winRate ?? 0.0),
                  icon: Icons.star,
                  color: Get.theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class StatCardDemo extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCardDemo({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Get.theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        const    SizedBox(height: 4),
          Text(
            title,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
