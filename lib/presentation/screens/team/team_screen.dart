import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/controllers/team_controller.dart';
import 'package:gain_quest/presentation/screens/team/team_detail_screen.dart';
import 'package:gain_quest/presentation/widgets/team_card.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class TeamsScreen extends StatelessWidget {
  final TeamsController controller = Get.put(TeamsController());

   TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement search
              Get.snackbar('Info', 'Search feature coming soon!');
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                String category = controller.categories[index];
                bool isSelected = controller.selectedCategory.value == category;
                
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      controller.selectCategory(category);
                    },
                    backgroundColor: Get.theme.colorScheme.surface,
                    selectedColor: Get.theme.primaryColor.withOpacity(0.2),
                    checkmarkColor: Get.theme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Get.theme.primaryColor : null,
                      fontWeight: isSelected ? FontWeight.w600 : null,
                    ),
                  ),
                );
              },
            )),
          ),
          
          // Teams List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.teams.isEmpty) {
                return _buildShimmerList();
              }

              if (controller.filteredTeams.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.loadTeams,
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: controller.filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = controller.filteredTeams[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: TeamCard(
                                team: team,
                                onTap: () => Get.to(() => TeamDetailScreen(team: team)),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 64,
            color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'No teams found',
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try changing the category filter',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Get.theme.colorScheme.surface,
      highlightColor: Get.theme.colorScheme.onSurface.withOpacity(0.1),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}