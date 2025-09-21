import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gain_quest/data/models/team_model.dart';
import 'package:get/get.dart';

class TeamHeaderBackground extends StatelessWidget {
  final TeamModel team;

  const TeamHeaderBackground({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                placeholder: (context, url) =>
                    Icon(Icons.group, size: 40, color: Get.theme.primaryColor),
                errorWidget: (context, url, error) =>
                    Icon(Icons.group, size: 40, color: Get.theme.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
