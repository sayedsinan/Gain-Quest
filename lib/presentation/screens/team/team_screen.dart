import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/controllers/team_controller.dart';
import 'package:gain_quest/presentation/screens/team/team_detail_screen.dart';
import 'package:gain_quest/presentation/widgets/category_filter.dart' show CategoryFilter;
import 'package:gain_quest/presentation/widgets/empty_state.dart';
import 'package:gain_quest/presentation/widgets/error_state.dart';
import 'package:gain_quest/presentation/widgets/shimmer_state.dart';
import 'package:gain_quest/presentation/widgets/team_card.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class TeamsScreen extends StatelessWidget {
  final TeamsController controller = Get.put(TeamsController());

  TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar(
                'Info',
                'Search feature coming soon!',
                snackPosition: SnackPosition.TOP,
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          CategoryFilter(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.teams.isEmpty) {
                return ShimmerList();
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return ErrorState(controller: controller);
              }

              final filteredTeams = controller.filteredTeams;

              if (filteredTeams.isEmpty) {
                return const   EmptyState(
                  message: 'No teams found',
                  icon: Icons.sports_soccer,
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadTeams,
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = filteredTeams[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TeamCard(
                                team: team,
                                onTap: () {
                                  _handleFollowPressed(team.id);
                                  Get.to(() => TeamDetailScreen(team: team));
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
          ),
        ],
      ),
    );
  }

  void _handleFollowPressed(String teamId) {
    if (controller.isTeamFollowed(teamId)) {
      controller.unfollowTeam(teamId);
    } else {
      controller.followTeam(teamId);
    }
  }
}





