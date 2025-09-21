import 'package:flutter/material.dart';
import 'package:gain_quest/core/widgets/custom_button.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:gain_quest/presentation/controllers/team_controller.dart';
import 'package:get/get.dart';

class FollowButtonSection extends StatelessWidget {
  final TeamModel team;
  final TeamsController controller;

  const FollowButtonSection({super.key, required this.team, required this.controller});

  @override
  Widget build(BuildContext context) {
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
}

