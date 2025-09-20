import 'package:flutter/material.dart';
import 'package:gain_quest/core/widgets/custom_button.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:gain_quest/presentation/controllers/team_controller.dart';
import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';

class TeamDetailScreen extends StatelessWidget {
  final TeamModel team;
  final TeamsController controller = Get.find<TeamsController>();

  TeamDetailScreen({required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                team.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Get.theme.primaryColor.withOpacity(0.8),
                          Get.theme.primaryColor.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: team.logoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Icon(
                            Icons.group,
                            size: 40,
                            color: Get.theme.primaryColor,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.group,
                            size: 40,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              if (team.isLive)
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTeamInfo(),
                  SizedBox(height: 24),
                  _buildStatsSection(),
                  SizedBox(height: 24),
                  _buildMembersSection(),
                  SizedBox(height: 24),
                  _buildFollowButton(),
                  SizedBox(height: 24),
                  if (team.isLive) _buildLiveStreamSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfo() {
    return Container(
      padding: EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Get.theme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  team.category,
                  style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              Icon(
                Icons.people_outline,
                size: 16,
                color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              SizedBox(width: 4),
              Text(
                '${team.followersCount} followers',
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'About the Team',
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            team.description,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: Get.theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(20),
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
          Text(
            'Performance Stats',
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Win Rate',
                  value: '${team.winRate.toStringAsFixed(1)}%',
                  icon: Icons.emoji_events,
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Total Challenges',
                  value: '${team.totalChallenges}',
                  icon: Icons.flag,
                  color: Get.theme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Challenges Won',
                  value: '${team.challengesWon}',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatCard(
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

  Widget _buildMembersSection() {
    return Container(
      padding: EdgeInsets.all(20),
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
          Row(
            children: [
              Text(
                'Team Members',
                style: Get.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                '${team.members.length}',
                style: Get.theme.textTheme.headlineMedium?.copyWith(
                  color: Get.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...team.members.map((member) => Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: Get.theme.primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  member,
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildFollowButton() {
    return Obx(() {
      bool isFollowed = controller.isTeamFollowed(team.id);
      return CustomButton(
        text: isFollowed ? 'Unfollow Team' : 'Follow Team',
        onPressed: () => controller.followTeam(team.id),
        isOutlined: isFollowed,
        icon: isFollowed ? Icons.favorite : Icons.favorite_border,
        backgroundColor: isFollowed ? null : Get.theme.colorScheme.secondary,
      );
    });
  }

  Widget _buildLiveStreamSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Team is Live!',
                style: Get.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Join the live stream to see what the team is working on right now!',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 16),
          CustomButton(
            text: 'Watch Live Stream',
            onPressed: () {
              // TODO: Navigate to live stream
              Get.snackbar('Info', 'Live stream feature coming soon!');
            },
            backgroundColor: Colors.red,
            icon: Icons.play_arrow,
          ),
        ],
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
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}