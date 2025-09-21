import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gain_quest/presentation/controllers/home_controller.dart';
import 'package:gain_quest/presentation/widgets/bet_card.dart';
import 'package:gain_quest/presentation/widgets/empty_state.dart';
import 'package:gain_quest/presentation/widgets/section_header.dart';
import 'package:gain_quest/presentation/widgets/shimmer_state.dart';
import 'package:get/get.dart';

class RecentBetsSection extends StatelessWidget {
  final HomeController homeController;

  const RecentBetsSection({
    super.key,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Bets',
          onViewAllPressed: () {
            Get.snackbar('Info', 'View all bets feature coming soon!');
          },
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (homeController.isLoading.value &&
              homeController.userBets.isEmpty) {
            return ShimmerList();
          }

          if (homeController.userBets.isEmpty) {
            return EmptyState(
              message: 'No bets placed yet',
              icon: Icons.sports_handball,
            );
          }

          return AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: homeController.userBets.take(3).map((bet) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: BetCard(bet: bet),
                  );
                }).toList(),
              ),
            ),
          );
        }),
      ],
    );
  }
}
