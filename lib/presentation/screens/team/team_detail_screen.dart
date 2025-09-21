import 'package:flutter/material.dart';

import 'package:gain_quest/data/models/team_model.dart';
import 'package:gain_quest/presentation/controllers/team_controller.dart';
import 'package:gain_quest/presentation/widgets/follow_button_section.dart';
import 'package:gain_quest/presentation/widgets/live_badge.dart';
import 'package:gain_quest/presentation/widgets/live_stream_section.dart';
import 'package:gain_quest/presentation/widgets/member_section.dart';

import 'package:gain_quest/presentation/widgets/team_header.dart';
import 'package:gain_quest/presentation/widgets/team_info_section.dart';
import 'package:gain_quest/presentation/widgets/team_stat_section.dart';
import 'package:get/get.dart';


class TeamDetailScreen extends StatelessWidget {
  final TeamModel team;
  final TeamsController controller = Get.find<TeamsController>();

  TeamDetailScreen({super.key, required this.team});

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
                      offset:const  Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              background: TeamHeaderBackground(team: team),
            ),
            actions: [
              if (team.isLive) const LiveBadge(),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TeamInfoSection(team: team),
                  const SizedBox(height: 24),
                  TeamStatSection(team: team),
                  const SizedBox(height: 24),
                  MembersSection(team: team),
                  const SizedBox(height: 24),
                  FollowButtonSection(team: team, controller: controller),
                  const SizedBox(height: 24),
                  if (team.isLive) const LiveStreamSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



