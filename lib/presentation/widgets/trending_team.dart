import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gain_quest/presentation/controllers/home_controller.dart';
import 'package:gain_quest/presentation/widgets/empty_state.dart' ;
import 'package:gain_quest/presentation/widgets/section_header.dart';
import 'package:gain_quest/presentation/widgets/shimmer_state.dart';
import 'package:gain_quest/presentation/widgets/team_card.dart';
import 'package:get/get.dart';

class TrendingTeamsSection extends StatelessWidget {
  final HomeController homeController;

  const TrendingTeamsSection({
    Key? key,
    required this.homeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Trending Teams',
          onViewAllPressed: () {
            Get.snackbar('Info', 'View all teams feature coming soon!');
          },
        ),
       const  SizedBox(height: 16),
        Obx(() {
          if (homeController.isLoading.value && homeController.trendingTeams.isEmpty) {
            return ShimmerGrid();
          }

          if (homeController.trendingTeams.isEmpty) {
            return const EmptyState(
              message: 'No trending teams',
              icon: Icons.trending_up,
            );
          }

          return SizedBox(
            height: 200,
            child: AnimationLimiter(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeController.trendingTeams.length,
                itemBuilder: (context, index) {
                  final team = homeController.trendingTeams[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding:const  EdgeInsets.only(right: 16),
                          child: TeamCard(
                            team: team,
                            width: 160,
                            onTap: () {
                              Get.snackbar('Info', 'Team details feature coming soon!');
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}

