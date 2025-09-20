import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gain_quest/presentation/controllers/home_controller.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';
import 'package:gain_quest/presentation/controllers/theme_controller.dart';
import 'package:gain_quest/presentation/widgets/challenge_card.dart';
import 'package:gain_quest/presentation/widgets/team_card.dart';
import 'package:gain_quest/presentation/widgets/bet_card.dart';
import 'package:gain_quest/core/widgets/custom_button.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: homeController.refreshDashboard,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 24),
                _buildStatsCards(),
                SizedBox(height: 32),
                _buildActiveChalllenges(),
                SizedBox(height: 32),
                _buildTrendingTeams(),
                SizedBox(height: 32),
                _buildRecentBets(),
                SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                'Hello, ${authController.currentUser.value?.name ?? 'User'}! 👋',
                style: Get.theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )),
              SizedBox(height: 4),
              Text(
                'Ready to win big today?',
                style: Get.theme.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            CustomIconButton(
              icon: themeController.isDarkMode.value 
                  ? Icons.light_mode 
                  : Icons.dark_mode,
              onPressed: themeController.toggleTheme,
              tooltip: 'Toggle Theme',
            ),
            SizedBox(width: 8),
            CustomIconButton(
              icon: Icons.notifications_outlined,
              onPressed: () {
                // TODO: Implement notifications
                Get.snackbar('Info', 'Notifications feature coming soon!');
              },
              tooltip: 'Notifications',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Obx(() {
      final user = authController.currentUser.value;
      if (user == null) return SizedBox.shrink();

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
                child: _StatCard(
                  title: 'Credits',
                  value: '${user.credits}',
                  icon: Icons.account_balance_wallet,
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Total Winnings',
                  value: '${user.totalWinnings}',
                  icon: Icons.trending_up,
                  color: Color(0xFFFFD93D),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Win Rate',
                  value: '${user.winRate.toStringAsFixed(1)}%',
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

  Widget _buildActiveChalllenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Challenges',
              style: Get.theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all challenges
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() {
          if (homeController.isLoading.value && homeController.activeChallenges.isEmpty) {
            return _buildShimmerList();
          }

          if (homeController.activeChallenges.isEmpty) {
            return _buildEmptyState('No active challenges', Icons.sports_esports);
          }

          return AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: homeController.activeChallenges.take(3).map((challenge) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: ChallengeCard(
                      challenge: challenge,
                      onBetPressed: (challengeId, teamId, credits, prediction) {
                        homeController.placeBet(challengeId, teamId, credits, prediction);
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

  Widget _buildTrendingTeams() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trending Teams',
              style: Get.theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to teams screen
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() {
          if (homeController.isLoading.value && homeController.trendingTeams.isEmpty) {
            return _buildShimmerGrid();
          }

          if (homeController.trendingTeams.isEmpty) {
            return _buildEmptyState('No trending teams', Icons.trending_up);
          }

          return Container(
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
                          padding: EdgeInsets.only(right: 16),
                          child: TeamCard(
                            team: team,
                            width: 160,
                            onTap: () {
                              // TODO: Navigate to team details
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

  Widget _buildRecentBets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Bets',
              style: Get.theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all bets
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() {
          if (homeController.isLoading.value && homeController.userBets.isEmpty) {
            return _buildShimmerList();
          }

          if (homeController.userBets.isEmpty) {
            return _buildEmptyState('No bets placed yet', Icons.sports_handball);
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

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            SizedBox(height: 12),
            Text(
              message,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Get.theme.colorScheme.surface,
      highlightColor: Get.theme.colorScheme.onSurface.withOpacity(0.1),
      child: Column(
        children: List.generate(3, (index) => 
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Get.theme.colorScheme.surface,
      highlightColor: Get.theme.colorScheme.onSurface.withOpacity(0.1),
      child: Container(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(right: 16),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
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
          SizedBox(height: 8),
          Text(
            value,
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
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