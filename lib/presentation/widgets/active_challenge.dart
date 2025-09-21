import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gain_quest/presentation/controllers/home_controller.dart';
import 'package:gain_quest/presentation/widgets/challenge_card.dart';
import 'package:gain_quest/presentation/widgets/empty_state.dart';
import 'package:gain_quest/presentation/widgets/section_header.dart';
import 'package:gain_quest/presentation/widgets/shimmer_state.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ActiveChallengesSection extends StatelessWidget {
  final HomeController homeController;

  const ActiveChallengesSection({
    super.key,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Active Challenges',
          onViewAllPressed: () {
            Get.snackbar('Info', 'View all challenges feature coming soon!');
          },
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (homeController.isLoading.value &&
              homeController.activeChallenges.isEmpty) {
            return ShimmerList();
          }

          if (homeController.activeChallenges.isEmpty) {
            return const EmptyState(
              message: 'No active challenges',
              icon: Icons.sports_esports,
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
                children:
                    homeController.activeChallenges.take(3).map((challenge) {
                  return Padding(
                    padding:const  EdgeInsets.only(bottom: 12),
                    child: ChallengeCard(
                      challenge: challenge,
                      onBetPressed: (challengeId, teamId, credits, prediction) {
                        homeController.placeBet(
                            challengeId, teamId, credits, prediction);
                      },
                    ),
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
