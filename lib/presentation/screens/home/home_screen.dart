import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gain_quest/presentation/controllers/home_controller.dart';
import 'package:gain_quest/presentation/controllers/auth_controller.dart';
import 'package:gain_quest/presentation/controllers/theme_controller.dart';

import 'package:gain_quest/presentation/widgets/home_header.dart';
import 'package:gain_quest/presentation/widgets/stats_card.dart';
import 'package:gain_quest/presentation/widgets/active_challenge.dart';
import 'package:gain_quest/presentation/widgets/trending_team.dart';
import 'package:gain_quest/presentation/widgets/recent_bet.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(
                  authController: authController,
                  themeController: themeController,
                ),
                const SizedBox(height: 24),
                StatsCards(authController: authController),
                const SizedBox(height: 32),
                ActiveChallengesSection(homeController: homeController),
                const SizedBox(height: 32),
                TrendingTeamsSection(homeController: homeController),
                const SizedBox(height: 32),
                RecentBetsSection(homeController: homeController),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
